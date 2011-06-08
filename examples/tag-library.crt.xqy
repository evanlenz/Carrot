^(product-documentation) :=
  <table class="table2">
    <h2>Documentation</h2>
    <tbody>{^product-doc-entry(doc | old-doc)}</tbody>
  </table>;

    ^product-doc-entry(*) :=
      let $title := ^product-doc-title(.)  
      let $url   := ^product-doc-url(.) return
      <tr>
        <td>
          <a href="{$url}">{text{$title},`&#160;`,text{@version}}</a>
        </td>
        <td>
          <a href="{$url}">{
            if (ends-with(lower-case($url), 'pdf')) then
              <img src="/images/icon_pdf.png" alt="View PDF for {$title}"/> else
            if (ends-with(lower-case($url), 'zip')) then
              <img src="/images/icon_zip.png" alt="Download zip file for {$title}"/>
            else
              <img src="/images/icon_browser.png" alt="View HTML for {$title}"/>
          }</a>
        </td>
      </tr>;

          ^product-doc-title(old-doc) := text{@desc};
          ^product-doc-title(doc)     := text{document(@source)/Article/title};

          ^product-doc-url(old-doc)   := text{@path};
          ^product-doc-url(doc)       :=
            let $source := document(@source) return
            if ($source/Article/external-link/@href/normalize-space(.))
            then $source/Article/external-link/@href
            else ml:external-uri($source);
      


^( upcoming-user-group-events ) :=
  let $events := ml:most-recent-two-user-group-events(string(@group)) return
  <div class="double">
    <h2>Events</h2>
    <a class="more" href="/events">All events&#160;></a>
    { $events/(
        <div>
          { ^event-excerpt(. ; tunnel $suppress-more-link   := true(),
                               tunnel $suppress-description := true()) }
        </div>
      )
    }
  </div>;

     ^event-excerpt( Event ; tunnel $suppress-description) :=
       <h3>{ ^(title/node()) }</h3>,
       if (not($suppress-description)) then ^(description//teaser/node()) else (),
       <dl>{ ^event-details(details/*) }</dl>,
       <a class="more" href="{ml:external-uri(.)}">More information&#160;</a>,
       ^more-link(.),
       if (position() != last()) then
         <_><br/> &#160; <br/> &#160; <br/></_>/node() else ();

          ^more-link( * ; tunnel $suppress-more-link as xs:boolean() := false()) :=
            if (not($suppress-more-link)) then
              <div class="more">
                <a href="{^more-link-href(.)}">{^more-link-text(.)}&#160;></a>
              </div>
            else ();

                ^more-link-href( Event        ) := `/events`;
                ^more-link-href( Announcement ) := `/news`;

                ^more-link-text( Event        ) := `More Events`;
                ^more-link-text( Announcement ) := `More Announcements`;

          (: TODO: For dates and times, consider use ISO 8601 format (in the source data) instead :)
          ^event-details( * ) :=
            <dt>
              <strong>{^event-detail-name(.)}</strong>{`:&#160;`}
            </dt>
            <dd>{^()}</dd>;

              ^event-detail-name(date)      := `Date`;
              ^event-detail-name(time)      := `Time`;
              ^event-detail-name(location)  := `Location`;
              ^event-detail-name(topic)     := `Topic`;
              ^event-detail-name(presenter) := `Presenter`;

