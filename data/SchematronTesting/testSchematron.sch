<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>
        

        <sch:rule context="tei:persName/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/person/')">@ref attributes must
                contain a properly formatted Syriaca.org person URI that starts with
                http://syriaca.org/person/.</sch:assert>
            <sch:report test="matches(substring-after(., 'person/'), '\D')">A properly formatted
                person URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'person/'), '\d')">A properly formatted
                person URI ends with a number.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:placeName/@ref">
            <sch:assert test="starts-with(., 'http://syriaca.org/place/')">@ref attributes must
                contain a properly formatted Syriaca.org place URI that starts with
                http://syriaca.org/place/.</sch:assert>
            <sch:report test="matches(substring-after(., 'place/'), '\D')">A properly formatted
                place URI ends with a number.</sch:report>
            <sch:assert test="matches(substring-after(., 'place/'), '\d')">A properly formatted
                person URI ends with a number.</sch:assert>
        </sch:rule>

        <sch:rule context="tei:div/@uri">
            <sch:let name="docURIno"
                value="//tei:publicationStmt/tei:idno[@type]/substring-after(substring-before(., '/tei'), 'spear/')"/>
            <sch:let name="divURInos" value="//tei:div/@uri/substring-after(., 'spear/')"/>
            <sch:let name="divURIbaseNos"
                value="//tei:div/@uri/substring-after(substring-before(., '-'), 'spear/')"/>
            <sch:let name="uniquePartDivURIs" value="//tei:div/@uri/substring-after(., '-')"/>
            
            <sch:assert test="starts-with(., 'http://syriaca.org/spear/')">@uri attributes must
                contain a properly formatted SPEAR factoid div URI that starts with
                http://syriaca.org/spear/.</sch:assert>
            <sch:report test="matches(substring-after(., '-'), '\D')">A properly formatted SPEAR
                factoid URI ends with a hyphen followed by a number.</sch:report>
            <sch:assert test="matches(substring-after(., '-'), '\d')">A properly formatted SPEAR
                factoid URI ends with a number.</sch:assert>
            <sch:assert test="contains(., concat('/', $docURIno, '-'))"
                >SPEAR factoid divs contain @uri attributes that must contain the number of the TEI document
                URI, in this document: <sch:value-of select="$docURIno"/>.</sch:assert>

            <sch:assert test="count(distinct-values(//tei:div/@uri)) eq count(//tei:div/@uri)">Each
                div @uri attribute must have a unique value.</sch:assert>
            <!--
                <sch:assert test="count(distinct-values(.)) = count(.)">Each div @uri attribute must have a unique value.</sch:assert>
                <sch:assert test="count(distinct-values(.)) eq count(.)">Each div @uri attribute must have a unique value.</sch:assert>
                <sch:report test="count(.) gt count(distinct-values(.))">Each div @uri attribute must have a unique value.</sch:report>
                <sch:report test="count(distinct-values(.)) lt count(.)">Each div @uri attribute must have a unique value.</sch:report>
                I tried all of these but none worked. They validate whether or not the count of uri attribute values is the same or 
                greater than the number of unique uri attribute values. I couldn't figure out how this might be a namespace issue but 
                tried the sch:assert above and it worked. I'm not sure why it worked where the others failed.
            -->

        </sch:rule>
        
        <sch:rule context="tei:note[parent::tei:birth and preceding-sibling::tei:placeName]">
            <sch:assert test="tei:persName">The note in a birth place factoid must contain a persName element.</sch:assert>
            <sch:assert test="tei:placeName">The note in a birth place factoid must contain a placeName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:birth and preceding-sibling::tei:date]">
            <sch:assert test="tei:persName">The note in a birth date factoid must contain a persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:nationality and preceding-sibling::tei:placeName]">
            <sch:assert test="tei:persName">The note in a citizenship factoid must contain a persName element.</sch:assert>
            <sch:assert test="tei:placeName">The note in a citizenship factoid must contain a placeName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:death and preceding-sibling::tei:placeName]">
            <sch:assert test="tei:persName">The note in a death place factoid must contain a persName element.</sch:assert>
            <sch:assert test="tei:placeName">The note in a birth place factoid must contain a placeName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:death and preceding-sibling::tei:date]">
            <sch:assert test="tei:persName">The note in a death date factoid must contain a persName element.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[parent::tei:education]">
            <sch:assert test="tei:persName">The note in an education factoid must contain a persName element.</sch:assert>
            <sch:assert test="@type['desc']">The note inside an education element must be type="desc".</sch:assert><!-- Figure out how to specify attribute values. This doesn't work! -->
        </sch:rule>



        
    </sch:pattern>
</sch:schema>