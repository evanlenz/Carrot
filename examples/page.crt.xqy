include navigation.crt;
include widgets.crt;
include comments.crt;
include tag-library.crt;
include xquery-imports.crt;

output doctype-public := "-//W3C//DTD XHTML 1.0 Strict//EN";
output doctype-system := "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd";
output omit-xml-declaration := "yes";

param $params as element()*;
param $error as xs:string*;
param $errorMessage as xs:string*;
param $errorDetail as xs:string*;

$DEBUG    := false();
$content  := /;
$template := if (xdmp:uri-is-file('/config/template.optimized.xhtml'))
                   then u:get-doc('/config/template.optimized.xhtml') 
                   else u:get-doc('/config/template.xhtml');

$preview-context := $params[@name eq 'preview-as-if-at'];
$external-uri    := if (normalize-space($preview-context)) then $preview-context
                                                           else ml:external-uri(/);

$site-title := "MarkLogic Developer Community";

$navigation := if ($navigation-cached) then $navigation-cached
                                       else ($populated-navigation,
                                             ml:save-cached-navigation($populated-navigation));

  $navigation-cached := ml:get-cached-navigation();

  $populated-navigation := document { ^pre-process-navigation($ml:raw-navigation) };


(: Start by processing the template file :)
^(/) := ^($template/*);

  ^(@*
   |comment()
   |text()
   |processing-instruction()
   )      := .;                      (: By default, copy everything unchanged. :)
  ^(ml:*) := ^();                    (: Strip out inline custom tags (such as <ml:teaser>) :)
  ^(*)    := element {node-name(.)}  (: For elements, "replicate," rather than copy, to prevent unwanted namespace nodes in the output :)
                     { ^(@*|node()) };

(: Canonical identity transform is like this; note the copy{} extension equivalent to <xsl:copy>
 ^(@*|node()) := copy{ ^(@*|node()) };
:)

(: What to put in the <title> tag :)
^(page-title) := ^page-title($content/*);

    ^page-title( page[$external-uri eq '/'] ) := $site-title;
    ^page-title( *                          ) := ^page-specific-title(.),` &#8212; `,$site-title;  (: I'm using ` to delimit a "text node literal" :)

        ^page-specific-title( page ) := text{( xhtml:h1
                                             | xhtml:div/xhtml:h1
                                             | xhtml:h2
                                             | xhtml:div/xhtml:h2
                                             )[1]};
        ^page-specific-title( page[product-info]               ) := text{product-info/@name};
        ^page-specific-title( page[$external-uri eq '/search'] ) := `Search results for "`,text{($params[@name eq 'q'])},`"`;
        ^page-specific-title( Project                          ) := text{name};
        ^page-specific-title( Announcement
                            | Event
                            | Article
                            | Post)                              := text{title};

^(errors) := 
  <h2>{$error} &#8212; {$errorMessage}</h2>,
  <pre>{$errorDetail}</pre>;

^(xhtml:input[@name eq 'q']/@ml:value) :=
  attribute value { $params[@name eq 'q'] };

^(page-content) :=
  if ($DEBUG) then $params else (),
  ^page-content   ( $content/*),
  ^comment-section( $content/*);

    ^page-content( page ) := ^();
    ^page-content( Post ) :=
      <h1>Blog<h1>,
      ^blog-post(.);

        ^blog-post
        |paginated-list-item( Post ; $disable-comment-count := true() ) :=
           (:Overridden when grouped with other posts in the same page (mode="paginated-list-item");
             Remains disabled when we're just displaying one blog post, because the comment count
             automatically appears above the comment submit form section. Suppressing it by default
             ensures we don't display it twice.:)

            <div class="post">
                <h2 class="title-with-links">
                    {^(title/node())}
                    <a class="permalink" href="{ml:external-uri(.)}" title="Permalink">
                        <img src="/media/permalink.png" title="Permalink" alt="Permalink"/>
                    </a>
                </h2>
              <span class="date">
                {ml:display-date(created)}
              </span>
              <span class="author">
                {"by ",
                 ^author-listing(author)
                }
              </span>
              {^(body/node())}
              { if (not($disable-comment-count)) then ^comment-count(.) else () }
            </div>;

    ^page-content( Event ) := 
      <h1>Events</h1>,
      <h2>{^(title/node())}</h2>,
      <dl>{^event-details(details/*)}</dl>,
      ^(description/node());

    ^page-content( Article ) :=
      <div id="doc_search"/>,
      <h2>{^(title/node())}</h2>,
      <div class="author">{^author-listing(author)}</div>,
      <div class="date">{"Last updated ",$last-updated}</div>,
      <br/>,
      ^(body/node());

        ^author-listing( author[1]      ) 1 :=           ^();
        ^author-listing( author         )   := ", "    , ^();
        ^author-listing( author[last()] )   := " and " , ^();
    

    ^page-content( Project ) :=
      <h1>Code</h1>,
      <h2>{string(name)}</h2>,
      ^(description/node()), 
      if (versions/@get-involved-href) then  
        <div class="action repo">
          <a href="{versions/@get-involved-href}">
            Browse {string(versions/@repo)} repository
          </a>
        </div>
      else (),

      if (versions/version/@href) then
        <table class="table4">
          <thead>
            <tr>
              <th scope="col">
                Download
              </th>
              <th class="size" scope="col">MarkLogic Version Needed</th>
              (:
              <th class="last" scope="col">Date Posted</th>
              :)
            </tr>
          </thead>
          <tbody>
            {^project-version(versions/version)}
          </tbody>
        </table>
      else (),
      (:
      <div class="action">
        <a href="{contributors/@href}">Contributors</a>
      </div>
      :)
      ^(top-threads);
 

^project-version( version ) :=
  <tr>
    { if (position() mod 2 eq 1) then attribute class { "alt" } else (),
    <td>
      <a href="{@href}">{ml:file-from-path(@href)}</a>
      (:
      <a href="{@href}">{^file-from-path(string(@href))}</a>
      :)
    </td>
    <td>{ if (normalize-space(@server-version)) then
             (`MarkLogic Server `,text{@server-version},` or later`) else ()}</td>
  </tr>;


^page-content( Announcement ) :=
  <h1>News</h1>,
  (:
  <div class="date">{ ml:display-date(date) }</div>
    <xsl:value-of select="ml:display-date(date)"/>
  </div>,
  :)
  <div class="date">{ ^display-date(string(date)) }</div>,
  <h2>{ ^(title/node()) }</h2>,
  ^(body/node());


ml:display-date($date-or-dateTime as xs:string?) as xs:string :=
  let $date-part := substring($date-or-dateTime, 1, 10)
  let $castable  := $date-part castable as xs:date return
  if ($castable) then format-date(xs:date($date-part), '[M01]/[D01]/[Y01]')
                 else $date-or-dateTime;

ml:file-from-path($path as xs:string) as xs:string :=
  if (contains($path, '/')) then ml:file-from-path(substring-after($path, '/'))
                            else $path;

(:
^file-from-path( ~item() ) as xs:string :=
  if (contains($path, '/')) then ^file-from-path(substring-after($path, '/'))
                            else $path;
:)
