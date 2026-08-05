require 'spec_helper'

RSpec.describe TagScraper do
  describe '.to_markdown' do
    context 'with a bold tag' do
      it 'wraps content in double asterisks' do
        node = element_from('<b>hello</b>')
        expect(TagScraper.to_markdown(node)).to eq('**hello**')
      end
    end

    context 'with an italic tag' do
      it 'wraps content in single asterisks' do
        node = element_from('<i>hello</i>')
        expect(TagScraper.to_markdown(node)).to eq('*hello*')
      end
    end

    context 'with nested formatting' do
      it 'renders inner tags correctly' do
        node = element_from('<b>hello <i>world</i></b>')
        expect(TagScraper.to_markdown(node)).to eq('**hello *world***')
      end
    end
  end

  describe '.parse_anchor' do
    context 'with an external link' do
      it 'renders as a markdown link' do
        node = element_from('<a rel="mw:ExtLink nofollow" href="https://twitter.com/JColeNC/status/1393053698201296896" class="external text" id="mwBCw">"Took years to reach this form. The Off-Season. My new album. Available now"</a>')
        expect(TagScraper.parse_anchor(node)).to eq('["Took years to reach this form. The Off-Season. My new album. Available now"](https://twitter.com/JColeNC/status/1393053698201296896)')
      end
    end

    context 'with Wikipedia link' do
      it 'expands it to a full en.wikipedia.org URL' do
        node = element_from('<a href="//en.wikipedia.org/wiki/Wikipedia:Contact_us" title="How to contact Wikipedia"><span>Contact us</span></a>')
        expect(TagScraper.parse_anchor(node)).to eq('[Contact us](https://en.wikipedia.org/wiki/Wikipedia:Contact_us)')
      end
    end

    context 'when there is only the title attribute and no text element for the link' do
      it 'falls back to the title attribute' do
        node = element_from('<a href="//en.wikipedia.org/wiki/Texas" title="Texas"></a>')
        expect(TagScraper.parse_anchor(node)).to eq('[Texas](https://en.wikipedia.org/wiki/Texas)')
      end
    end

    context 'when there is a Wikipedia edit link' do
      it 'returns nil' do
        node = element_from('<a href="https://www.wikidata.org/wiki/Q106717344#identifiers" title="Edit this at Wikidata"></a>')
        expect(TagScraper.parse_anchor(node)).to be_nil
      end
    end
  end

  describe '.markdown_node with <li>' do
    it 'joins multiple list items with a comma separator' do
      node = element_from('<div class="hlist"><ul><li>Cole</li><li>Gloria Jones</li><li>Pamela Sawyer</li></ul></div>')
      expect(TagScraper.to_markdown(node)).to eq('Cole, Gloria Jones, Pamela Sawyer')
    end
  end

  describe '.parse_table' do
    context 'with a real table' do
      html = <<~HTML
        <table class="wikitable plainrowheaders" id="mwA9o">
          <caption id="mwA9s">List of release dates, showing region, format(s), label(s) and reference(s)</caption>
          <tbody id="mwA9w">
              <tr id="mwA90">
                <th scope="col" id="mwA94">Region</th>
                <th scope="col" id="mwA98">Date</th>
                <th scope="col" id="mwA-A">Format</th>
                <th scope="col" id="mwA-E">Label</th>
                <th scope="col" id="mwA-I"><abbr title="Reference" about="#mwt559" typeof="mw:Transclusion mw:ExpandedAttrs" id="mwA-Q" data-mw="{&quot;attribs&quot;:[[{&quot;txt&quot;:&quot;title&quot;},{&quot;html&quot;:&quot;&lt;span typeof=\&quot;mw:Nowiki\&quot; id=\&quot;mwA-M\&quot;&gt;Reference&lt;/span&gt;&quot;}]],&quot;parts&quot;:[{&quot;template&quot;:{&quot;target&quot;:{&quot;wt&quot;:&quot;abbr&quot;,&quot;href&quot;:&quot;./Template:Abbr&quot;},&quot;params&quot;:{&quot;1&quot;:{&quot;wt&quot;:&quot;Ref.&quot;},&quot;2&quot;:{&quot;wt&quot;:&quot;Reference&quot;}},&quot;i&quot;:0}}]}">Ref.</abbr></th>
              </tr>
              <tr id="mwA-U">
                <th scope="row" rowspan="3" id="mwA-Y">Various</th>
                <td id="mwA-c">May 14, 2021</td>
                <td id="mwA-g">
                    <span class="mw-empty-elt" about="#mwt561" typeof="mw:Transclusion" id="mwA-k" data-mw="{&quot;parts&quot;:[{&quot;template&quot;:{&quot;target&quot;:{&quot;wt&quot;:&quot;hlist&quot;,&quot;href&quot;:&quot;./Template:Hlist&quot;},&quot;params&quot;:{&quot;1&quot;:{&quot;wt&quot;:&quot;[[Music download|digital download]]&quot;},&quot;2&quot;:{&quot;wt&quot;:&quot;[[Streaming media|streaming]]&quot;}},&quot;i&quot;:0}}]}">
                      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r1333133064" about="#mwt562" typeof="mw:Extension/templatestyles" data-mw="{&quot;name&quot;:&quot;templatestyles&quot;,&quot;attrs&quot;:{&quot;src&quot;:&quot;Hlist/styles.css&quot;},&quot;body&quot;:{&quot;extsrc&quot;:&quot;&quot;}}">
                    </span>
                    <div class="hlist" about="#mwt561" id="mwA-o">
                      <ul>
                          <li><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Music_download" title="Music download">digital download</a></li>
                          <li><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Streaming_media" title="Streaming media">streaming</a></li>
                      </ul>
                    </div>
                </td>
                <td rowspan="3" id="mwA-s">
                    <span class="mw-empty-elt" about="#mwt563" typeof="mw:Transclusion" id="mwA-w" data-mw="{&quot;parts&quot;:[{&quot;template&quot;:{&quot;target&quot;:{&quot;wt&quot;:&quot;hlist&quot;,&quot;href&quot;:&quot;./Template:Hlist&quot;},&quot;params&quot;:{&quot;1&quot;:{&quot;wt&quot;:&quot;[[Dreamville Records|Dreamville]]&quot;},&quot;2&quot;:{&quot;wt&quot;:&quot;[[Roc Nation]]&quot;},&quot;3&quot;:{&quot;wt&quot;:&quot;[[Interscope Records|Interscope]]&quot;}},&quot;i&quot;:0}}]}">
                      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r1333133064" about="#mwt564" typeof="mw:Extension/templatestyles" data-mw="{&quot;name&quot;:&quot;templatestyles&quot;,&quot;attrs&quot;:{&quot;src&quot;:&quot;Hlist/styles.css&quot;},&quot;body&quot;:{&quot;extsrc&quot;:&quot;&quot;}}">
                    </span>
                    <div class="hlist" about="#mwt563" id="mwA-0">
                      <ul>
                          <li><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Dreamville_Records" title="Dreamville Records">Dreamville</a></li>
                          <li><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Roc_Nation" title="Roc Nation">Roc Nation</a></li>
                          <li><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Interscope_Records" title="Interscope Records">Interscope</a></li>
                      </ul>
                    </div>
                </td>
                <td align="center" id="mwA-4"><sup about="#mwt565" class="mw-ref reference" id="cite_ref-releaseday_23-1" rel="dc:references" typeof="mw:Extension/ref" data-mw="{&quot;name&quot;:&quot;ref&quot;,&quot;attrs&quot;:{&quot;name&quot;:&quot;releaseday&quot;}}"><a href="#cite_note-releaseday-23" id="mwA-8"><span class="mw-reflink-text" id="mwA_A"><span class="cite-bracket" id="mwA_E">[</span>23<span class="cite-bracket" id="mwA_I">]</span></span></a></sup></td>
              </tr>
              <tr id="mwA_M">
                <td id="mwA_Q">July 16, 2021</td>
                <td id="mwA_U">
                    <span class="mw-empty-elt" about="#mwt566" typeof="mw:Transclusion" id="mwA_Y" data-mw="{&quot;parts&quot;:[{&quot;template&quot;:{&quot;target&quot;:{&quot;wt&quot;:&quot;hlist&quot;,&quot;href&quot;:&quot;./Template:Hlist&quot;},&quot;params&quot;:{&quot;1&quot;:{&quot;wt&quot;:&quot;[[Compact disc|CD]]&quot;}},&quot;i&quot;:0}}]}">
                      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r1333133064" about="#mwt567" typeof="mw:Extension/templatestyles" data-mw="{&quot;name&quot;:&quot;templatestyles&quot;,&quot;attrs&quot;:{&quot;src&quot;:&quot;Hlist/styles.css&quot;},&quot;body&quot;:{&quot;extsrc&quot;:&quot;&quot;}}">
                    </span>
                    <div class="hlist" about="#mwt566" id="mwA_c">
                      <ul>
                          <li><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Compact_disc" title="Compact disc">CD</a></li>
                      </ul>
                    </div>
                </td>
                <td rowspan="2" id="mwA_g"><sup about="#mwt570" class="mw-ref reference" id="cite_ref-122" rel="dc:references" typeof="mw:Extension/ref" data-mw="{&quot;name&quot;:&quot;ref&quot;,&quot;attrs&quot;:{},&quot;body&quot;:{&quot;id&quot;:&quot;mw-reference-text-cite_note-122&quot;}}"><a href="#cite_note-122" id="mwA_k"><span class="mw-reflink-text" id="mwA_o"><span class="cite-bracket" id="mwA_s">[</span>122<span class="cite-bracket" id="mwA_w">]</span></span></a></sup></td>
              </tr>
              <tr id="mwA_0">
                <td id="mwA_4">August 27, 2021</td>
                <td id="mwA_8"><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Phonograph_record" title="Phonograph record" id="mwBAA">Vinyl LP</a></td>
              </tr>
          </tbody>
        </table>
      HTML

      node = element_from(html, 'table')
      result = TagScraper.parse_table([node])

      it 'checks the whole table' do 
        expect(result).to eq(
          [
            "List of release dates, showing region, format(s), label(s) and reference(s)",
            [
              "Region",
              "Date",
              "Format",
              "Label",
              "Ref."
            ],
            [
              "Various",
              "May 14, 2021",
              "[digital download](https://en.wikipedia.org/wiki/Music_download), [streaming](https://en.wikipedia.org/wiki/Streaming_media)",
              "[Dreamville](https://en.wikipedia.org/wiki/Dreamville_Records), [Roc Nation](https://en.wikipedia.org/wiki/Roc_Nation), [Interscope](https://en.wikipedia.org/wiki/Interscope_Records)",
              "[23]"
            ],
            [
              "Various",
              "[CD](https://en.wikipedia.org/wiki/Compact_disc)",
              "[122]",
              "[Dreamville](https://en.wikipedia.org/wiki/Dreamville_Records), [Roc Nation](https://en.wikipedia.org/wiki/Roc_Nation), [Interscope](https://en.wikipedia.org/wiki/Interscope_Records)",
              nil
            ],
            [
              "Various",
              "[Vinyl LP](https://en.wikipedia.org/wiki/Phonograph_record)",
              "[122]",
              "[Dreamville](https://en.wikipedia.org/wiki/Dreamville_Records), [Roc Nation](https://en.wikipedia.org/wiki/Roc_Nation), [Interscope](https://en.wikipedia.org/wiki/Interscope_Records)",
              nil
            ]
          ])
      end

      it 'checks duplicate spanned rows' do
        expect(result[2][0]).to eq(result[3][0])
      end

      it 'checks the caption as the first row' do
        expect(result.first).to eq('List of release dates, showing region, format(s), label(s) and reference(s)')
      end
    end
  end

  describe '.parse_list' do
    it 'extracts numbers and text from reference items' do
      html = <<~HTML
        <ol class="mw-references references" id="mwBA8">
          <li about="#cite_note-1" id="cite_note-1" data-mw-footnote-number="1">
              <span class="mw-cite-backlink" id="mwBBA"><a href="#cite_ref-1" rel="mw:referencedBy" id="mwBBE" aria-label="Jump up" title="Jump up"><span class="mw-linkback-text" id="mwBBI">↑</span></a></span> 
              <span id="mw-reference-text-cite_note-1" class="mw-reference-text reference-text">
                <style data-mw-deduplicate="TemplateStyles:r1333433106" typeof="mw:Extension/templatestyles" about="#mwt10" id="mwBBM" data-mw="{&quot;name&quot;:&quot;templatestyles&quot;,&quot;attrs&quot;:{&quot;src&quot;:&quot;Module:Citation/CS1/styles.css&quot;},&quot;body&quot;:{&quot;extsrc&quot;:&quot;&quot;}}">.mw-parser-output cite.citation{font-style:inherit;word-wrap:break-word}.mw-parser-output .citation q{quotes:"\"""\"""'""'"}.mw-parser-output .citation:target{background-color:rgba(0,127,255,0.133)}.mw-parser-output .id-lock-free.id-lock-free a{background:url("//upload.wikimedia.org/wikipedia/commons/6/65/Lock-green.svg")right 0.1em center/9px no-repeat}.mw-parser-output .id-lock-limited.id-lock-limited a,.mw-parser-output .id-lock-registration.id-lock-registration a{background:url("//upload.wikimedia.org/wikipedia/commons/d/d6/Lock-gray-alt-2.svg")right 0.1em center/9px no-repeat}.mw-parser-output .id-lock-subscription.id-lock-subscription a{background:url("//upload.wikimedia.org/wikipedia/commons/a/aa/Lock-red-alt-2.svg")right 0.1em center/9px no-repeat}.mw-parser-output .cs1-ws-icon a{background:url("//upload.wikimedia.org/wikipedia/commons/4/4c/Wikisource-logo.svg")right 0.1em center/12px no-repeat}body:not(.skin-timeless):not(.skin-minerva) .mw-parser-output .id-lock-free a,body:not(.skin-timeless):not(.skin-minerva) .mw-parser-output .id-lock-limited a,body:not(.skin-timeless):not(.skin-minerva) .mw-parser-output .id-lock-registration a,body:not(.skin-timeless):not(.skin-minerva) .mw-parser-output .id-lock-subscription a,body:not(.skin-timeless):not(.skin-minerva) .mw-parser-output .cs1-ws-icon a{background-size:contain;padding:0 1em 0 0}.mw-parser-output .cs1-code{color:inherit;background:inherit;border:none;padding:inherit}.mw-parser-output .cs1-hidden-error{display:none;color:var(--color-error,#bf3c2c)}.mw-parser-output .cs1-visible-error{color:var(--color-error,#bf3c2c)}.mw-parser-output .cs1-maint{display:none;color:#085;margin-left:0.3em}.mw-parser-output .cs1-kern-left{padding-left:0.2em}.mw-parser-output .cs1-kern-right{padding-right:0.2em}.mw-parser-output .citation .mw-selflink{font-weight:inherit}@media screen{.mw-parser-output .cs1-format{font-size:95%}html.skin-theme-clientpref-night .mw-parser-output .cs1-maint{color:#18911f}}@media screen and (prefers-color-scheme:dark){html.skin-theme-clientpref-os .mw-parser-output .cs1-maint{color:#18911f}}</style>
                <cite class="citation web cs1" id="mwBBQ"><a rel="mw:ExtLink nofollow" href="https://www.youtube.com/watch?v=2jivieOJAvU&amp;feature=emb_title" class="external text" id="mwBBU">"Applying Pressure ft. Dreamville Records President, Ibrahim Hamad - Say Less w/ Kaz, Low Key, &amp; Rosy"</a>. May 24, 2021<span class="reference-accessdate" id="mwBBY">. Retrieved <span class="nowrap" id="mwBBc">May 25,</span> 2021</span> <span typeof="mw:Entity" id="mwBBg">–</span> via <a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/YouTube" title="YouTube" id="mwBBk">YouTube</a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Applying+Pressure+ft.+Dreamville+Records+President%2C+Ibrahim+Hamad+-+Say+Less+w%2F+Kaz%2C+Low+Key%2C+%26+Rosy&amp;rft.date=2021-05-24&amp;rft_id=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D2jivieOJAvU%26feature%3Demb_title&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AThe+Off-Season" class="Z3988" id="mwBBo"></span>
              </span>
          </li>
          <li about="#cite_note-bb-2" id="cite_note-bb-2" data-mw-footnote-number="2">
              <span rel="mw:referencedBy" class="mw-cite-backlink" id="mwBBs"><a href="#cite_ref-bb_2-0" id="mwBBw"><span class="cite-accessibility-label">Jump up to: </span><span class="mw-linkback-text" id="mwBB0">1</span></a> <a href="#cite_ref-bb_2-1" id="mwBB4"><span class="mw-linkback-text" id="mwBB8">2</span></a></span> 
              <span id="mw-reference-text-cite_note-bb-2" class="mw-reference-text reference-text">
                <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r1333433106" about="#mwt234" typeof="mw:Extension/templatestyles" id="mwBCA" data-mw="{&quot;name&quot;:&quot;templatestyles&quot;,&quot;attrs&quot;:{&quot;src&quot;:&quot;Module:Citation/CS1/styles.css&quot;},&quot;body&quot;:{&quot;extsrc&quot;:&quot;&quot;}}">
                <cite class="citation magazine cs1" id="mwBCE"><a rel="mw:ExtLink nofollow" href="https://www.billboard.com/lists/best-rap-albums-hip-hop-2021/j-cole-the-offseason/" class="external text" id="mwBCI">"This year marked the return of some of hip-hop's biggest giants, but only one took home the crown on 2021's year's best hip-hop album list"</a>. <i id="mwBCM"><a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Billboard_(magazine)" title="Billboard (magazine)" id="mwBCQ">Billboard</a></i>. December 20, 2021<span class="reference-accessdate" id="mwBCU">. Retrieved <span class="nowrap" id="mwBCY">January 14,</span> 2022</span>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.jtitle=Billboard&amp;rft.atitle=This+year+marked+the+return+of+some+of+hip-hop%27s+biggest+giants%2C+but+only+one+took+home+the+crown+on+2021%27s+year%27s+best+hip-hop+album+list.&amp;rft.date=2021-12-20&amp;rft_id=https%3A%2F%2Fwww.billboard.com%2Flists%2Fbest-rap-albums-hip-hop-2021%2Fj-cole-the-offseason%2F&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AThe+Off-Season" class="Z3988" id="mwBCc"></span>
              </span>
          </li>
          <li about="#cite_note-3" id="cite_note-3" data-mw-footnote-number="3">
              <span class="mw-cite-backlink" id="mwBCg"><a href="#cite_ref-3" rel="mw:referencedBy" id="mwBCk" aria-label="Jump up" title="Jump up"><span class="mw-linkback-text" id="mwBCo">↑</span></a></span> 
              <span id="mw-reference-text-cite_note-3" class="mw-reference-text reference-text">
                <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r1333433106" about="#mwt17" typeof="mw:Extension/templatestyles mw:Transclusion" id="mwBCs" data-mw="{&quot;name&quot;:&quot;templatestyles&quot;,&quot;attrs&quot;:{&quot;src&quot;:&quot;Module:Citation/CS1/styles.css&quot;},&quot;body&quot;:{&quot;extsrc&quot;:&quot;&quot;},&quot;parts&quot;:[{&quot;template&quot;:{&quot;target&quot;:{&quot;wt&quot;:&quot;cite web &quot;,&quot;href&quot;:&quot;./Template:Cite_web&quot;},&quot;params&quot;:{&quot;author1&quot;:{&quot;wt&quot;:&quot;JColeNC&quot;},&quot;title&quot;:{&quot;wt&quot;:&quot;Took years to reach this form. The Off-Season. My new album. Available now.&quot;},&quot;url&quot;:{&quot;wt&quot;:&quot;https://twitter.com/JColeNC/status/1393053698201296896&quot;},&quot;via&quot;:{&quot;wt&quot;:&quot;[[Twitter]]&quot;},&quot;access-date&quot;:{&quot;wt&quot;:&quot;June 6, 2021&quot;},&quot;date&quot;:{&quot;wt&quot;:&quot;May 14, 2021&quot;}},&quot;i&quot;:0}}]}">
                <cite id="CITEREFJColeNC2021" class="citation web cs1" about="#mwt17">JColeNC (May 14, 2021). <a rel="mw:ExtLink nofollow" href="https://twitter.com/JColeNC/status/1393053698201296896" class="external text" id="mwBCw">"Took years to reach this form. The Off-Season. My new album. Available now"</a><span class="reference-accessdate" id="mwBC0">. Retrieved <span class="nowrap" id="mwBC4">June 6,</span> 2021</span> <span typeof="mw:Entity" id="mwBC8">–</span> via <a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Twitter" title="Twitter" class="mw-redirect" id="mwBDA">Twitter</a>.</cite><span title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=unknown&amp;rft.btitle=Took+years+to+reach+this+form.+The+Off-Season.+My+new+album.+Available+now.&amp;rft.date=2021-05-14&amp;rft.au=JColeNC&amp;rft_id=https%3A%2F%2Ftwitter.com%2FJColeNC%2Fstatus%2F1393053698201296896&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AThe+Off-Season" class="Z3988" about="#mwt17" id="mwBDE"></span>
              </span>
          </li>
          </span></span></li>
        </ol>
      HTML
      node = element_from(html, 'ol')
      expect(TagScraper.parse_list(node)).to eq([
        "1. [\"Applying Pressure ft. Dreamville Records President, Ibrahim Hamad - Say Less w/ Kaz, Low Key, & Rosy\"](https://www.youtube.com/watch?v=2jivieOJAvU&feature=emb_title). May 24, 2021. Retrieved May 25, 2021 – via [YouTube](https://en.wikipedia.org/wiki/YouTube).",
        "2. [\"This year marked the return of some of hip-hop's biggest giants, but only one took home the crown on 2021's year's best hip-hop album list\"](https://www.billboard.com/lists/best-rap-albums-hip-hop-2021/j-cole-the-offseason/). *[Billboard](https://en.wikipedia.org/wiki/Billboard_(magazine))*. December 20, 2021. Retrieved January 14, 2022.",
        "3. JColeNC (May 14, 2021). [\"Took years to reach this form. The Off-Season. My new album. Available now\"](https://twitter.com/JColeNC/status/1393053698201296896). Retrieved June 6, 2021 – via [Twitter](https://en.wikipedia.org/wiki/Twitter)."
      ])
    end
  end

  describe 'scraping div' do
    it 'extracts the list and text elements in div correctly' do
      html = <<~HTML
        <div class="hidden-begin mw-collapsible mw-collapsed" style="" about="#mwt129" id="mwAWg">
          <div class="hidden-title skin-nightmode-reset-color" style="text-align: center"><i>The Sopranos</i> credits</div>
          <div class="hidden-content mw-collapsible-content" style="">
            <dl><dt>Writer</dt></dl>
            <ul>
              <li>
                "<a
                  rel="mw:WikiLink"
                  href="https://en.wikipedia.org/wiki/The_Sopranos_(pilot_episode)"
                  title="The Sopranos (pilot episode)"
                  class="mw-redirect"
                  >The Sopranos</a
                >" <i>(episode 1.01)</i>
              </li>
              <li>
                "<a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/46_Long" title="46 Long">46 Long</a>"
                <i>(episode 1.02)</i>
              </li>
            </ul>
            <dl><dt>Director</dt></dl>
            <ul>
              <li>
                "<a
                  rel="mw:WikiLink"
                  href="https://en.wikipedia.org/wiki/The_Sopranos_(pilot_episode)"
                  title="The Sopranos (pilot episode)"
                  class="mw-redirect"
                  >The Sopranos</a
                >" <i>(episode 1.01)</i>
              </li>
              <li>
                "<a
                  rel="mw:WikiLink"
                  href="https://en.wikipedia.org/wiki/Made_in_America_(The_Sopranos)"
                  title="Made in America (The Sopranos)"
                  >Made in America</a
                >" <i>(episode 6.21)</i>
              </li>
            </ul>
            <dl><dt>Actor</dt></dl>
            Chase appeared as a man sitting at an outdoor cafe in
            <a rel="mw:WikiLink" href="https://en.wikipedia.org/wiki/Naples" title="Naples">Naples</a>, Italy smoking a
            cigarette in the season two episode "<a
              rel="mw:WikiLink"
              href="https://en.wikipedia.org/wiki/Commendatori"
              title="Commendatori"
              >Commendatori</a
            >". He also appeared as an airline passenger en route to Italy in season six's "<a
              rel="mw:WikiLink"
              href="https://en.wikipedia.org/wiki/Luxury_Lounge"
              title="Luxury Lounge"
              >Luxury Lounge</a
            >". His voice was also used over the phone in the episode "The Test Dream".
          </div>
        </div>
      HTML
      node = element_from(html, 'div')
      expect(simplify_array(TagScraper.scrape(node))).to eq([
        "*The Sopranos* credits",
        [
          "Writer",
          [
            "\"[The Sopranos](https://en.wikipedia.org/wiki/The_Sopranos_(pilot_episode))\" *(episode 1.01)*",
            "\"[46 Long](https://en.wikipedia.org/wiki/46_Long)\" *(episode 1.02)*"
          ],
          "Director",
          [
            "\"[The Sopranos](https://en.wikipedia.org/wiki/The_Sopranos_(pilot_episode))\" *(episode 1.01)*",
            "\"[Made in America](https://en.wikipedia.org/wiki/Made_in_America_(The_Sopranos))\" *(episode 6.21)*"
          ],
          "Actor",
          "Chase appeared as a man sitting at an outdoor cafe in [Naples](https://en.wikipedia.org/wiki/Naples), Italy smoking a cigarette in the season two episode \"[Commendatori](https://en.wikipedia.org/wiki/Commendatori)\". He also appeared as an airline passenger en route to Italy in season six's \"[Luxury Lounge](https://en.wikipedia.org/wiki/Luxury_Lounge)\". His voice was also used over the phone in the episode \"The Test Dream\"."
        ]
      ])
    end
  end
end
