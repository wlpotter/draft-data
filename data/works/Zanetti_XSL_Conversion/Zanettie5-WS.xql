xquery version "3.0";

(: Tested in eXide :)

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $uri := "https://raw.githubusercontent.com/srophe/draft-data/master/data/works/Zanetti_XSL_Conversion/ZanettiBiblFull-normalized-spaces-and-vertical-tabs.xml"
for $bibl in fn:doc($uri)//tei:bibl
let $citation := 
    for $bibl in analyze-string(normalize-space($bibl/text()),"^(.+?),\s*|[,]*\s*[p]\.\s*(\w*[-]*w*.*)$")/node()
    return 
        if ($bibl instance of element(fn:match)) then 
            if($bibl/fn:group[@nr='1']) then 
                <tei:author>{$bibl/fn:group[@nr='1']/text()}</tei:author>
            else if($bibl/fn:group[@nr='2']) then 
                <tei:citedRange unit="pp">{$bibl/fn:group[@nr='2']/text()}</tei:citedRange>
            else <tei:p>{$bibl/text()}</tei:p>
        else 
            for $titles in analyze-string($bibl/text(),"^(.*)[,][\s]*dans[\s]*|[\(]*([\d]+[\-]*[\d]*)[\)]*$")/node()
            return
                if ($titles instance of element(fn:match)) then 
                    if($titles/fn:group[@nr='1']) then 
                        <tei:title level="a">{$titles/fn:group[@nr='1']/text()}</tei:title>
                    else if($titles/fn:group[@nr='2']) then 
                        <tei:date>{$titles/fn:group[@nr='2']/text()}</tei:date>
                    else <tei:p>{$bibl/text()}</tei:p>
                else 
                    for $journal in analyze-string($bibl/text(), "^.*[,][\s]*dans[\s]*([\w\-:\s]*)[,]|[\s]*([\d]+)[\s]*\([\d\-]+\)$")/node()
                    return
                        if ($journal instance of element(fn:match)) then
                            if($journal/fn:group[@nr='1']) then 
                                <tei:title level="j">{$journal/fn:group[@nr='1']/text()}</tei:title>
                            else if($journal/fn:group[@nr='2']) then 
                                <tei:citedRange unit="vol">{$journal/fn:group[@nr='2']/text()}</tei:citedRange>
                            else <tei:p>{$journal/text()}</tei:p>
                        else 
                            for $publication in analyze-string($journal/text(), "[,][\s]*([\w\-\s]+)[,][\s]*[\d]{4}$")/node()
                            return
                                if ($publication instance of element(fn:match)) then
                                    if($publication/fn:group[@nr='1']) then 
                                        <tei:pubPlace>{$publication/fn:group[@nr='1']/text()}</tei:pubPlace>
                                    else <tei:p>{$publication/text()}</tei:p>
                                else 
                                    for $series in analyze-string($publication/text(), "\(([^\(]*)[,\s]+[\d]+\)$")/node()
                                    return
                                        if ($series instance of element(fn:match)) then
                                            if($series/fn:group[@nr='1']) then 
                                                <tei:title level="s">{replace($series/fn:group[@nr='1']/text(), "[,]$","")}</tei:title>
                                            else if($series/fn:group[@nr='2']) then 
                                                <tei:citedRange level="vol">{$series/fn:group[@nr='2']/text()}</tei:citedRange>
                                            else <tei:p>{$series/text()}</tei:p>
                                    else 
                                        for $series-vol in analyze-string($publication/text(), "\([^\(]*[,\s]+([\d]+)\)$")/node()
                                        return 
                                            if ($series-vol instance of element(fn:match)) then
                                                if($series-vol/fn:group[@nr='1']) then 
                                                    <tei:citedRange level="vol">{$series-vol/fn:group[@nr='1']/text()}</tei:citedRange>
                                                else <tei:p>{$series-vol/text()}</tei:p>
                                            else 
                                                for $editors in analyze-string(normalize-space($series-vol/text()), "[,\?][\s]*dans[\s]*(.+)[\s]+\([eé]d\.\)|[eé]d\.[\s]*par[\s]*(.*)$")/node()
                                                return 
                                                    if ($editors instance of element(fn:match)) then
                                                        if($editors/fn:group[@nr='1']) then 
                                                            <tei:editor>{$editors/fn:group[@nr='1']/text()}</tei:editor>
                                                        else if($editors/fn:group[@nr='2']) then 
                                                            <tei:editor>{$editors/fn:group[@nr='2']/text()}</tei:editor>
                                                        else <tei:p>{$editors/text()}</tei:p>
                                                else 
                                                    for $edited-book in analyze-string($editors/text(), "^[,][\s]+(.*)$")/node()
                                                    return
                                                        if ($edited-book instance of element(fn:match)) then
                                                            if($edited-book/fn:group[@nr='1']) then 
                                                                <tei:title level="m">{$edited-book/fn:group[@nr='1']/text()}</tei:title>
                                                            else <tei:p>{$edited-book/text()}</tei:p>
                                                        else <tei:p>{$edited-book/text()}</tei:p>
                                                
                                                
                                
(:                        there are enough Symposium Syriacum that this might deserve special handling:)
        
let $articeldatereturn := element tei:bibl {($bibl/@xml:id, $citation)}
return ($bibl,$articeldatereturn)