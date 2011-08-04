^(Carrot) := An appetizing hybrid of XQuery and XSLT
====================================================

Carrot combines the best that XQuery and XSLT have to offer:

  * the friendly syntax and composability of XQuery expressions, plus
  * the power and flexibility of template rules in XSLT.
  
Carrot can also be thought of as an alternative, more composable syntax
for XSLT.

Read the full [Balisage conference paper on Carrot](http://www.balisage.net/Proceedings/vol7/html/Lenz01/BalisageVol7-Lenz01.html).

What does it look like?
-----------------------

Carrot is best understood by example. Here's an example of XSLT's
syntax for a template rule (henceforth "rule"):

    <xsl:template match="para">
      <p>
        <xsl:apply-templates/>
      <p>
    </xsl:template>

In Carrot, you'd write the above rule like this:

    ^(para) := <p>{^()}</p>;

There are a few things to note about the above. To define a rule in Carrot,
you use the same operator that XQuery uses for binding variables (`:=`).
Everything on the right-hand side up to the semi-colon is an expression in
Carrot. An expression in Carrot is simply an XQuery expression, plus some
extensions. In this case, the expression is using the extended syntax for
invoking rules:

    ^()

which is short for:

    ^(node())

just as:

    <xsl:apply-templates/>

is short for:

    <xsl:apply-templates select="node()"/>

All rules belong to a *ruleset* (you can think of a ruleset as a polymorphic
function, if you like). The above examples use the unnamed ruleset (there's just
one of these). Here's an example that belongs to a ruleset named "toc":

    ^toc(section) := <li>{ ^toc() }</li>;

The above is short for:

    <xsl:template match="section" mode="toc">
      <li>
        <xsl:apply-templates mode="toc"/>
      </li>
    </xsl:template>

Here's the identity transform in Carrot:

    ^(@*|node()) := copy{ ^(@*|node()) };

This recursively copies the input to the output, one node at a time.

Here's a Carrot script that creates
an HTML document with dynamic content for its title and body, converting
`<para>` elements in the input to `<p>` elements in the output:

    ^(/) :=
      <html>
        <head>
          { /doc/title }
        </head>
        <body>
          { ^(/doc/para) }
        </body>
      </html>;

    ^(para) := <p>{ ^() }</p>;

As a comparison, here's what you'd have to write if you were using regular
XSLT:

    <xsl:transform version="2.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

      <xsl:template match="/">
        <html>
          <head>
            <xsl:copy-of select="/doc/title"/>
          </head>
          <body>
            <xsl:apply-templates select="/doc/para"/>
          </body>
        </html>
      </xsl:template>

      <xsl:template match="para">
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:template>

    </xsl:transform>



How Carrot compares to XQuery
-----------------------------

Carrot adds the ability to define rulesets. A *ruleset* is like a function, except
that you define it differently. With a function, you define it in one place, and 
then you're done. A ruleset is defined using one or more lexically separate *rules*.

Extensions to XQuery expressions
--------------------------------

Carrot adds just three extensions to XQuery's syntax for expressions:

  * shallow `copy{}` constructors
  * ruleset invocations - `^mode(nodes)`
  * text node literals - `` `my text node` ``


How Carrot compares to XSLT
---------------------------

A ruleset is another name for a mode in XSLT...

