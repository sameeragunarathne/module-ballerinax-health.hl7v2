// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.hl7v23;
import ballerinax/health.hl7v231;
import ballerinax/health.hl7v24;
import ballerinax/health.hl7v25;
import ballerinax/health.hl7v251;
import ballerinax/health.hl7v26;
import ballerinax/health.hl7v27;
import ballerinax/health.hl7v271;
import ballerinax/health.hl7v28;

// --------------------------------------------------------------------------------------------#
// Source HL7 Version 2 to FHIR - Datatype Maps
// URL: https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/datatype_maps.html
// --------------------------------------------------------------------------------------------#

public isolated function ceToCodings(Ce ce) returns r4:Coding[]? {
    r4:Coding[] codings = [];

    // Add primary coding if any of the primary fields are present
    if (ce.ce1 != "" || ce.ce2 != "" || ce.ce3 != "") {
        r4:Coding primaryCoding = {
            code: (ce.ce1 != "") ? ce.ce1 : (),
            display: (ce.ce2 != "") ? ce.ce2 : (),
            system: (ce.ce3 != "") ? ce.ce3 : ()
        };
        if (primaryCoding != {}) {
            codings.push(primaryCoding);
        }
    }

    // Add alternate coding if any of the alternate fields are present
    if (ce.ce4 != "" || ce.ce5 != "" || ce.ce6 != "") {
        r4:Coding alternateCoding = {
            code: (ce.ce4 != "") ? ce.ce4 : (),
            display: (ce.ce5 != "") ? ce.ce5 : (),
            system: (ce.ce6 != "") ? ce.ce6 : ()
        };
        if (alternateCoding != {}) {
            codings.push(alternateCoding);
        }
    }

    return (codings.length() > 0) ? codings : ();
};

public isolated function cweToCodings(Cwe ce) returns r4:Coding[]? {
    r4:Coding[] codings = [];
    r4:Coding cweToCodingResult = cweToCoding(ce);
    if cweToCodingResult != {} {
        codings.push(cweToCodingResult);
    }
    return (codings.length() > 0) ? codings : ();
}

public isolated function ceToCodeableConcept(Ce ce) returns r4:CodeableConcept => {
    coding: ceToCodings(ce)
};

public isolated function cweToCodeableConcept(Cwe cwe) returns r4:CodeableConcept => {
    coding: cweToCodings(cwe)
};

public isolated function cweToDuration(Cwe cwe) returns r4:Duration? {
    string code = cwe.cwe1 != "" ? cwe.cwe1 : cwe.cwe2;

    return code != "" ? {
        code: code
    } : ();
};

public isolated function cweToIdentifier(Cwe cwe) returns r4:Identifier[] {
    r4:Identifier[] identifiers = [];

    // Primary identifier
    if cwe.cwe1 != "" || cwe.cwe2 != "" || cwe.cwe3 != "" {
        r4:Identifier primaryIdentifier = {
            value: cwe.cwe1,
            system: cwe.cwe3 != "" ? string `urn:oid:${cwe.cwe3}` : ()
        };
        if primaryIdentifier != {} {
            identifiers.push(primaryIdentifier);
        }
    }

    // Alternate identifier
    if cwe.cwe4 != "" || cwe.cwe5 != "" || cwe.cwe6 != "" {
        r4:Identifier alternateIdentifier = {
            value: cwe.cwe4,
            system: cwe.cwe6 != "" ? string `urn:oid:${cwe.cwe6}` : ()
        };
        if alternateIdentifier != {} {
            identifiers.push(alternateIdentifier);
        }
    }

    return identifiers;
};

public isolated function cweToQuantity(Cwe cwe) returns r4:Quantity? {
    r4:Quantity quantity = {
        code: cwe.cwe1,
        unit: cwe.cwe1 != "" ? cwe.cwe1 : cwe.cwe2,
        system: cwe.cwe3 != "" ? string `urn:oid:${cwe.cwe3}` : ()
    };

    return (quantity.code != "" || quantity.unit != "" || quantity.system != "") ? quantity : ();
};

public isolated function cweToString(Cwe cwe) returns string? {
    return cwe.cwe2 != "" ? cwe.cwe2 : cwe.cwe9;
};

public isolated function cweToCode(Cwe cwe) returns r4:code? {
    return cwe.cwe1 != "" ? cwe.cwe1 : cwe.cwe4;
};

public isolated function ceToCoding(Ce ce) returns r4:Coding => {
    code: (ce.ce1 != "") ? ce.ce1 : (),
    display: (ce.ce2 != "") ? ce.ce2 : (),
    system: (ce.ce3 != "") ? ce.ce3 : ()
};

public isolated function cweToCoding(Cwe cwe) returns r4:Coding => {
    code: (cwe.cwe1 != "") ? cwe.cwe1 : (),
    display: (cwe.cwe2 != "") ? cwe.cwe2 : (),
    system: (cwe.cwe3 != "") ? cwe.cwe3 : ()
};

public isolated function xadToAddress(Xad xad) returns r4:Address? {
    r4:Extension[]? extension = [];
    string district = "";

    if xad is hl7v23:XAD|hl7v231:XAD|hl7v24:XAD|hl7v25:XAD|hl7v251:XAD|hl7v26:XAD {
        extension = getStringExtension([xad.xad7, <string>xad.xad10]);
        district = xad.xad9;
    } else if xad is hl7v27:XAD|hl7v28:XAD {
        extension = getStringExtension([xad.xad7, xad.xad10.cwe1]);
        district = xad.xad9.cwe1;
    }

    r4:Address address = {
        city: (xad.xad3 != "") ? xad.xad3 : (),
        state: (xad.xad4 != "") ? xad.xad4 : (),
        postalCode: (xad.xad5 != "") ? xad.xad5 : (),
        country: (xad.xad6 != "") ? xad.xad6 : (),
        'type: checkComputableAntlr([{identifier: xad.xad7, comparisonOperator: "IN", valueList: ["M", "SH"]}]) ? idToAddressType(xad.xad7) : (),
        use: checkComputableAntlr([{identifier: xad.xad7, comparisonOperator: "IN", valueList: ["BA", "BI", "C", "B", "H", "O"]}]) ? idToAddressUse(xad.xad7) : (),
        district: (district != "") ? district : ()
    };
    address.extension = extension;
    if xad is hl7v23:XAD {
        if xad.xad1 != "" && xad.xad2 != "" {
            address.line = [xad.xad1, xad.xad2];
        } else if xad.xad1 != "" {
            address.line = [xad.xad1];
        } else if xad.xad2 != "" {
            address.line = [xad.xad2];
        }
    } else if xad is hl7v24:XAD|hl7v25:XAD {
        if xad.xad1.sad1 != "" && xad.xad2 != "" {
            address.line = [xad.xad1.sad1, xad.xad2];
        } else if xad.xad1.sad1 != "" {
            address.line = [xad.xad1.sad1];
        } else if xad.xad2 != "" {
            address.line = [xad.xad2];
        }
    }
    return (address != {}) ? address : ();
};

public isolated function xonToOrganization(Xon xon) returns international401:Organization {
    string? xon3 = ();
    if xon is hl7v23:XON|hl7v231:XON|hl7v24:XON|hl7v25:XON|hl7v251:XON|hl7v26:XON {
        xon3 = (xon.xon3 != "") ? xon.xon3.toString() : ();
    }
    r4:Identifier identifier = {
        value: xon3,
        'type: (xon.xon7 != "") ? {
                coding: [
                    {
                        code: xon.xon7,
                        system: string `urn:oid: ${xon.xon7}`
                    }
                ]
            } : ()
    };

    international401:Organization organization = {
        name: (xon.xon1 != "") ? xon.xon1 : (),
        identifier: (identifier != {}) ? [identifier] : ()
    };

    return organization;
};

public isolated function xonToReference(Xon xon) returns r4:Reference? {
    string? xon3 = ();
    if xon is hl7v23:XON|hl7v231:XON|hl7v24:XON|hl7v25:XON|hl7v251:XON|hl7v26:XON {
        xon3 = (xon.xon3 != "") ? xon.xon3.toString() : ();
    }
    r4:Identifier identifier = {
        value: xon3,
        'type: (xon.xon7 != "") ? {
                coding: [
                    {
                        code: xon.xon7,
                        system: string `urn:oid: ${xon.xon7}`
                    }
                ]
            } : ()
    };
    r4:Reference reference = {
        identifier: (identifier != {}) ? identifier : ()
    };
    return (reference != {}) ? reference : ();
};

public isolated function xpnToHumanName(Xpn xpn) returns r4:HumanName {
    r4:HumanName humanName = {
        use: (xpn.xpn7 != "") ? idToHumanNameUse(xpn.xpn7) : ()
    };
    if xpn is hl7v23:XPN {
        humanName.family = (xpn.xpn1 != "") ? xpn.xpn1 : ();
    } else if xpn is hl7v231:XPN|hl7v24:XPN|hl7v25:XPN|hl7v251:XPN|hl7v26:XPN|hl7v27:XPN|hl7v28:XPN {
        humanName.family = (xpn.xpn1.fn1 != "") ? xpn.xpn1.fn1 : ();
    }
    //given
    if xpn.xpn2 != "" && xpn.xpn3 != "" {
        humanName.given = [xpn.xpn2, xpn.xpn3];
    } else if xpn.xpn2 != "" {
        humanName.given = [xpn.xpn2];
    } else if xpn.xpn3 != "" {
        humanName.given = [xpn.xpn3];
    }
    //suffix
    string[] suffix = [];
    if xpn is hl7v27:XPN|hl7v28:XPN {
        suffix = [xpn.xpn4, xpn.xpn14];
    } else if xpn is hl7v23:XPN|hl7v231:XPN|hl7v24:XPN|hl7v25:XPN|hl7v251:XPN|hl7v26:XPN {
        suffix = [xpn.xpn4, xpn.xpn6];
    }
    if suffix[0] != "" && suffix[1] != "" {
        humanName.suffix = suffix;
    } else if suffix[0] != "" {
        humanName.suffix = [suffix[0]];
    } else if suffix[1] != "" {
        humanName.suffix = [suffix[1]];
    }
    //prefix
    if xpn.xpn5 != "" {
        humanName.prefix = [xpn.xpn5];
    }
    return humanName;
};

public isolated function xtnToContactPoint(Xtn xtn) returns r4:ContactPoint? {
    r4:ContactPoint contactPoint = {
        use: idToContactPointUse(xtn.xtn2),
        system: idToContactPointSystem(xtn.xtn3),
        extension: xtn.xtn5 != "-1.0" ? getStringExtension([xtn.xtn5.toString()]) : (),
        value: ()
    };

    if xtn is hl7v23:XTN|hl7v231:XTN|hl7v24:XTN|hl7v25:XTN|hl7v251:XTN {
        if (xtn.xtn3 != "Internet" || xtn.xtn3 != "X.400") && xtn.xtn7 != "" {
            contactPoint.value = xtn.xtn1;
        }
    }
    if contactPoint.value == "" {
        return ();
    }
    return contactPoint;
};

public isolated function hdToMessageHeaderSource(Hd hd) returns international401:MessageHeaderSource {
    return {
        name: (hd.hd1 != "") ? hd.hd1 : (),
        endpoint: hd.hd2,
        extension: getStringExtension([hd.hd3])
    };
};

public isolated function hdToMessageHeaderDestination(Hd hd) returns international401:MessageHeaderDestination => {
    name: (hd.hd1 != "") ? hd.hd1 : (),
    endpoint: hd.hd2,
    extension: getStringExtension([hd.hd3])
};

public isolated function msgToCoding(hl7v23:CM_MSG msg) returns r4:Coding => {
    code: (msg.cm_msg1 != "") ? msg.cm_msg1 : (),
    system: (msg.cm_msg2 != "") ? msg.cm_msg2 : ()
};

public isolated function msgToCode(hl7v23:CM_MSG msg) returns r4:code? {
    // MSG.2 (Trigger Event) maps to $this (the code value itself)
    return (msg.cm_msg2 != "") ? <r4:code>msg.cm_msg2 : ();
};

public isolated function ptToMeta(Pt pt) returns r4:Meta {
    return {
        tag: [
            {
                code: (pt.pt1 != "") ? pt.pt1 : (),
                system: (pt.pt2 != "") ? pt.pt2 : ()
            }
        ]
    };
};

public isolated function ceToCode(Ce ce) returns r4:code? {
    return (ce.ce1 != "") ? ce.ce1 : ();
};

public isolated function eiToIdentifier(Ei ei) returns r4:Identifier => {
    value: (ei.ei1 != "") ? ei.ei1 : ()
};

public isolated function eiToReferenceWithType(Ei ei, string resourceType) returns r4:Reference {
    return {
        reference: (ei.ei1 != "") ? string `${resourceType}/${ei.ei1}` : ()
    };
};

public isolated function idToCodeableConceptArray(Id id) returns r4:CodeableConcept[] {
    r4:CodeableConcept[] codeableConcept = [];
    r4:CodeableConcept? idToCodeableConceptResult = idToCodeableConcept(id);
    if idToCodeableConceptResult is r4:CodeableConcept {
        codeableConcept.push(idToCodeableConceptResult);
    }
    return codeableConcept;
}

public isolated function eiToCoding(Ei ei) returns r4:Coding => {
    code: (ei.ei1 != "") ? ei.ei1 : (),
    system: (ei.ei2 != "") ? ei.ei2 : ()
};

public isolated function ceToUri(Ce ce) returns r4:uri? {
    return (ce.ce1 != "") ? ce.ce1 : ();
};

public isolated function cweToUri(Cwe cwe) returns r4:uri? {
    return (cwe.cwe1 != "") ? cwe.cwe1 : ();
};

public isolated function xcnToCodeableConcept(Xcn xcn) returns r4:CodeableConcept {
    return {
        id: (xcn.xcn1 != "") ? xcn.xcn1 : ()
    };
};

public isolated function xcnToReference(Xcn xcn) returns r4:Reference {
    return {
        reference: (xcn.xcn1 != "") ? xcn.xcn1 : ()
    };
};

public isolated function xcnToReferenceWithType(Xcn xcn, string resourceType) returns r4:Reference {
    return {
        reference: (xcn.xcn1 != "") ? string `${resourceType}/${xcn.xcn1}` : ()
    };
};

public isolated function idToCoding(hl7v23:ID id) returns r4:Coding {
    return {
        id: (id != "") ? id : ()
    };
};

public isolated function ceToCodeableConcepts(Ce|hl7v26:CWE ce) returns r4:CodeableConcept[] {
    r4:CodeableConcept[] codeableConcept = [];
    if ce is hl7v26:CWE {
        codeableConcept.push(cweToCodeableConcept(ce));
    } else {
        codeableConcept.push(ceToCodeableConcept(<Ce>ce));
    }
    return codeableConcept;
}

public isolated function dtmToDateTime(Dtm ts) returns r4:dateTime? {
    return (ts != "") ? hl7DateToFhir(ts) : ();
};

public isolated function tsToDateTime(Ts ts) returns r4:dateTime? {
    return (ts.ts1 != "") ? hl7DateToFhir(ts.ts1) : ();
};

public isolated function idToCodeableConcept(hl7v23:ID id) returns r4:CodeableConcept? {

    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: id
            }
        ]
    };
    return id != "" ? codeableConcept : ();
};

public isolated function dtmToInstant(Dtm ts) returns r4:instant {
    return ts;
};

public isolated function tsToInstant(Ts ts) returns r4:instant? {
    return (ts.ts1 != "") ? ts.ts1 : ();
};

# Union type for CE data type for all supported hl7 versions.
public type Ce hl7v23:CE|hl7v231:CE|hl7v24:CE|hl7v25:CE|hl7v251:CE;

# Union type for CF data type for all supported hl7 versions.
public type Cf hl7v23:CF|hl7v231:CF|hl7v24:CF|hl7v25:CF|hl7v251:CF|hl7v26:CF|hl7v27:CF|hl7v28:CF;

# Union type for CQ data type for all supported hl7 versions.
public type Cq hl7v231:CQ|hl7v24:CQ|hl7v25:CQ|hl7v251:CQ|hl7v26:CQ|hl7v27:CQ|hl7v28:CQ;

# Union type for CNE data type for all supported hl7 versions.
public type Cne hl7v231:CNE|hl7v24:CNE|hl7v25:CNE|hl7v251:CNE|hl7v26:CNE|hl7v27:CNE|hl7v28:CNE;

# Union type for CWE data type for all supported hl7 versions.
public type Cwe hl7v231:CWE|hl7v24:CWE|hl7v25:CWE|hl7v251:CWE|hl7v26:CWE|hl7v27:CWE|hl7v28:CWE;

# Union type for XAD data type for all supported hl7 versions.
public type Xad hl7v23:XAD|hl7v231:XAD|hl7v24:XAD|hl7v25:XAD|hl7v251:XAD|hl7v26:XAD|hl7v27:XAD|hl7v28:XAD;

# Union type for XON data type for all supported hl7 versions.
public type Xon hl7v23:XON|hl7v231:XON|hl7v24:XON|hl7v25:XON|hl7v251:XON|hl7v26:XON|hl7v27:XON|hl7v28:XON;

# Union type for XPN data type for all supported hl7 versions.
public type Xpn hl7v23:XPN|hl7v231:XPN|hl7v24:XPN|hl7v25:XPN|hl7v251:XPN|hl7v26:XPN|hl7v27:XPN|hl7v28:XPN;

# Union type for XTN data type for all supported hl7 versions.
public type Xtn hl7v23:XTN|hl7v231:XTN|hl7v24:XTN|hl7v25:XTN|hl7v251:XTN|hl7v26:XTN|hl7v27:XTN|hl7v28:XTN;

# Union type for HD data type for all supported hl7 versions.
public type Hd hl7v23:HD|hl7v231:HD|hl7v24:HD|hl7v25:HD|hl7v251:HD|hl7v26:HD|hl7v27:HD|hl7v28:HD;

# Union type for PT data type for all supported hl7 versions.
public type Pt hl7v23:PT|hl7v231:PT|hl7v24:PT|hl7v25:PT|hl7v251:PT|hl7v26:PT|hl7v27:PT|hl7v28:PT;

# Union type for EI data type for all supported hl7 versions.
public type Ei hl7v23:EI|hl7v231:EI|hl7v24:EI|hl7v25:EI|hl7v251:EI|hl7v26:EI|hl7v27:EI|hl7v28:EI;

# Union type for ID data type for all supported hl7 versions.
public type Id hl7v23:ID|hl7v231:ID|hl7v24:ID|hl7v25:ID|hl7v251:ID|hl7v26:ID|hl7v27:ID|hl7v28:ID;

# Union type for XCN data type for all supported hl7 versions.
public type Xcn hl7v23:XCN|hl7v231:XCN|hl7v24:XCN|hl7v25:XCN|hl7v251:XCN|hl7v26:XCN|hl7v27:XCN|hl7v28:XCN;

# Union type for DTM data type for all supported hl7 versions.
public type Dtm hl7v23:DTM|hl7v25:DTM|hl7v251:DTM|hl7v26:DTM;

# Union type for TS data type for all supported hl7 versions.
public type Ts hl7v23:TS|hl7v231:TS|hl7v24:TS|hl7v25:TS|hl7v251:TS;

# Union type for CX data type for all supported hl7 versions.
public type Cx hl7v23:CX|hl7v231:CX|hl7v24:CX|hl7v25:CX|hl7v251:CX|hl7v26:CX|hl7v27:CX|hl7v28:CX;

# Union type for DLN data type for all supported hl7 versions.
public type Dln hl7v23:DLN|hl7v231:DLN|hl7v24:DLN|hl7v25:DLN|hl7v251:DLN|hl7v26:DLN|hl7v27:DLN|hl7v28:DLN;

# Union type for DR data type for all supported hl7 versions.
public type Dr hl7v23:DR|hl7v231:DR|hl7v24:DR|hl7v25:DR|hl7v251:DR|hl7v26:DR|hl7v27:DR|hl7v28:DR;

# Union type for FN data type for all supported hl7 versions.
public type Fn hl7v231:FN|hl7v24:FN|hl7v25:FN|hl7v251:FN|hl7v26:FN|hl7v27:FN|hl7v28:FN;

# Union type for IS data type for all supported hl7 versions.
public type Is hl7v23:IS|hl7v231:IS|hl7v24:IS|hl7v25:IS|hl7v251:IS|hl7v26:IS|hl7v27:IS|hl7v28:IS;

# Union type for NM data type for all supported hl7 versions.
public type Nm hl7v23:NM|hl7v231:NM|hl7v24:NM|hl7v25:NM|hl7v251:NM|hl7v26:NM|hl7v27:NM|hl7v28:NM;

public isolated function cfToCodeableConcept(Cf cf) returns r4:CodeableConcept {
    r4:Coding[] codings = [];

    // Add primary coding if any of the primary fields are present
    if (cf.cf1 != "" || cf.cf2 != "" || cf.cf3 != "") {
        r4:Coding primaryCoding = {
            code: (cf.cf1 != "") ? cf.cf1 : (),
            display: (cf.cf2 != "") ? cf.cf2 : (),
            system: (cf.cf3 != "") ? cf.cf3 : ()
        };
        if (primaryCoding != {}) {
            codings.push(primaryCoding);
        }
    }

    // Add alternate coding if any of the alternate fields are present
    if (cf.cf4 != "" || cf.cf5 != "" || cf.cf6 != "") {
        r4:Coding alternateCoding = {
            code: (cf.cf4 != "") ? cf.cf4 : (),
            display: (cf.cf5 != "") ? cf.cf5 : (),
            system: (cf.cf6 != "") ? cf.cf6 : ()
        };
        if (alternateCoding != {}) {
            codings.push(alternateCoding);
        }
    }

    return {
        coding: codings
    };
};

public isolated function cneToCodeableConcept(Cne cne) returns r4:CodeableConcept {
    r4:Coding[] codings = [];

    // Add primary coding if any of the primary fields are present
    if (cne.cne1 != "" || cne.cne2 != "" || cne.cne3 != "") {
        r4:Coding primaryCoding = {
            code: (cne.cne1 != "") ? cne.cne1 : (),
            display: (cne.cne2 != "") ? cne.cne2 : (),
            system: (cne.cne3 != "") ? cne.cne3 : (),
            version: (cne.cne7 != "") ? cne.cne7 : ()
        };
        if (primaryCoding != {}) {
            codings.push(primaryCoding);
        }
    }

    // Add alternate coding if any of the alternate fields are present
    if (cne.cne4 != "" || cne.cne5 != "" || cne.cne6 != "") {
        r4:Coding alternateCoding = {
            code: (cne.cne4 != "") ? cne.cne4 : (),
            display: (cne.cne5 != "") ? cne.cne5 : (),
            system: (cne.cne6 != "") ? cne.cne6 : (),
            version: (cne.cne8 != "") ? cne.cne8 : ()
        };
        if (alternateCoding != {}) {
            codings.push(alternateCoding);
        }
    }

    return {
        coding: codings,
        text: (cne.cne9 != "") ? cne.cne9 : ()
    };
};

public isolated function cqToQuantity(Cq cq) returns r4:Quantity? {
    decimal|error value = decimal:fromString(cq.cq1);
    if value is decimal {
        r4:Quantity quantity = {
            value: value
        };
        if cq.cq2 is hl7v26:CWE {
            quantity.unit = (<hl7v26:CWE>cq.cq2).cwe1;
        } else if cq.cq2 is hl7v27:CWE {
            quantity.unit = (<hl7v27:CWE>cq.cq2).cwe1;
        } else if cq.cq2 is hl7v28:CWE {
            quantity.unit = (<hl7v28:CWE>cq.cq2).cwe1;
        }
        return quantity;
    } else {
        return ();
    }
};

public isolated function cqToCode(Cq cq) returns r4:code? {
    if cq.cq2 is hl7v26:CWE {
        return (<hl7v26:CWE>cq.cq2).cwe1 != "" ? (<hl7v26:CWE>cq.cq2).cwe1 : ();
    } else if cq.cq2 is hl7v27:CWE {
        return (<hl7v27:CWE>cq.cq2).cwe1 != "" ? (<hl7v27:CWE>cq.cq2).cwe1 : ();
    } else if cq.cq2 is hl7v28:CWE {
        return (<hl7v28:CWE>cq.cq2).cwe1 != "" ? (<hl7v28:CWE>cq.cq2).cwe1 : ();
    }
    return ();
};

public isolated function cqToDecimal(Cq cq) returns decimal? {
    decimal|error value = decimal:fromString(cq.cq1);
    return value is decimal ? value : ();
};

public isolated function cqToUnsignedInt(Cq cq) returns int? {
    decimal|error value = decimal:fromString(cq.cq1);
    if value is decimal {
        // Convert to minutes based on CQ.2 unit
        string unit = "";
        if cq.cq2 is hl7v26:CWE {
            unit = (<hl7v26:CWE>cq.cq2).cwe1;
        } else if cq.cq2 is hl7v27:CWE {
            unit = (<hl7v27:CWE>cq.cq2).cwe1;
        } else if cq.cq2 is hl7v28:CWE {
            unit = (<hl7v28:CWE>cq.cq2).cwe1;
        }

        // Convert to minutes based on unit
        decimal minutes = value;
        if unit == "h" || unit == "hr" || unit == "hour" {
            minutes = value * 60;
        } else if unit == "d" || unit == "day" {
            minutes = value * 24 * 60;
        } else if unit == "wk" || unit == "week" {
            minutes = value * 7 * 24 * 60;
        } else if unit == "mo" || unit == "month" {
            minutes = value * 30 * 24 * 60;
        } else if unit == "a" || unit == "yr" || unit == "year" {
            minutes = value * 365 * 24 * 60;
        }

        // Convert to unsigned int (positive integer)
        int|error result = int:fromString(minutes.toString());
        return result is int && result >= 0 ? result : ();
    }
    return ();
};

public isolated function cxToIdentifier(Cx cx) returns r4:Identifier {
    r4:Identifier identifier = {
        value: (cx.cx1 != "") ? cx.cx1 : (),
        system: (cx.cx4.hd1 != "") ? string `urn:oid:${cx.cx4.hd1}` : (),
        'type: (cx.cx5 != "") ? {
            coding: [
                {
                    code: cx.cx5
                }
            ]
        } : ()
    };

    // Add check digit extension if present
    if (cx.cx2 != "") {
        r4:Extension[] extensions = [];
        r4:Extension checkDigitExtension = {
            url: "http://hl7.org/fhir/StructureDefinition/identifier-checkDigit",
            valueString: cx.cx2
        };
        extensions.push(checkDigitExtension);

        // Add check digit scheme extension if present
        if (cx.cx3 != "") {
            r4:Extension checkDigitSchemeExtension = {
                url: "http://hl7.org/fhir/StructureDefinition/namingsystem-checkDigit",
                valueString: cx.cx3
            };
            extensions.push(checkDigitSchemeExtension);
        }

        identifier.extension = extensions;
    }

    return identifier;
};

public isolated function cxToString(Cx cx) returns string? {
    return cx.cx1 != "" ? cx.cx1 : ();
};

public isolated function dlnToIdentifier(Dln dln) returns r4:Identifier {
    string system = "";
    if dln.dln2 is hl7v271:CWE {
        system = (<hl7v271:CWE>dln.dln2).cwe1;
    } else if dln.dln2 is hl7v28:CWE {
        system = (<hl7v28:CWE>dln.dln2).cwe1;
    } else if dln.dln2 is hl7v27:CWE {
        system = (<hl7v27:CWE>dln.dln2).cwe1;
    } else {
        system = dln.dln1;
    }

    r4:Identifier identifier = {
        value: (dln.dln1 != "") ? dln.dln1 : (),
        system: (system != "") ? system : (),
        'type: {
            coding: [
                {
                    code: "DL",
                    system: "http://terminology.hl7.org/CodeSystem/v2-0203"
                }
            ]
        }
    };

    return identifier;
};

public isolated function drToPeriod(Dr dr) returns r4:Period? {
    r4:Period period = {};
    if dr.dr1 is hl7v23:TS|hl7v231:TS|hl7v24:TS|hl7v25:TS|hl7v251:TS {
        period.'start = (dr.dr1 != "") ? hl7DateToFhir((<hl7v23:TS|hl7v231:TS|hl7v24:TS|hl7v25:TS|hl7v251:TS>dr.dr1).ts1) : ();
        period.end = (dr.dr2 != "") ? hl7DateToFhir((<hl7v23:TS|hl7v231:TS|hl7v24:TS|hl7v25:TS|hl7v251:TS>dr.dr2).ts1) : ();
    } else if dr.dr1 is hl7v26:DTM|hl7v27:DTM|hl7v28:DTM {
        period.'start = (dr.dr1 != "") ? hl7DateToFhir(<string>dr.dr1) : ();
        period.end = (dr.dr2 != "") ? hl7DateToFhir(<string>dr.dr2) : ();
    }

    return (period.'start != () || period.end != ()) ? period : ();
};

public isolated function drToDateTime(Dr dr) returns r4:dateTime? {
    if dr.dr1 is hl7v23:TS|hl7v231:TS|hl7v24:TS|hl7v25:TS|hl7v251:TS {
        return (dr.dr1 != "") ? hl7DateToFhir((<hl7v23:TS|hl7v231:TS|hl7v24:TS|hl7v25:TS|hl7v251:TS>dr.dr1).ts1) : ();
    } else if dr.dr1 is hl7v26:DTM|hl7v27:DTM|hl7v28:DTM {
        return (dr.dr1 != "") ? hl7DateToFhir(<string>dr.dr1) : ();
    }
    return ();
};

public isolated function fnToHumanName(Fn fn) returns r4:HumanName {
    r4:HumanName humanName = {
        family: (fn.fn1 != "") ? fn.fn1 : ()
    };

    // Add extensions for family name components
    r4:Extension[] familyExtensions = [];

    // FN.2 (Own Surname Prefix) -> extension[1]
    if (fn.fn2 != "") {
        r4:Extension ownPrefixExtension = {
            url: "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix",
            valueString: fn.fn2
        };
        familyExtensions.push(ownPrefixExtension);
    }

    if (familyExtensions.length() > 0) {
        humanName.extension = familyExtensions;
    }

    return humanName;
};

public isolated function hdToIdentifier(Hd hd) returns r4:Identifier[] {
    r4:Identifier[] identifiers = [];

    // HD.1 (Namespace ID) -> value[1]
    if (hd.hd1 != "") {
        r4:Identifier namespaceIdentifier = {
            value: hd.hd1
        };
        identifiers.push(namespaceIdentifier);
    }

    // HD.2 (Universal ID) -> value[2]
    if (hd.hd2 != "") {
        r4:Identifier universalIdentifier = {
            value: hd.hd2,
            'type: (hd.hd3 != "") ? {
                coding: [
                    {
                        code: hd.hd3
                    }
                ]
            } : ()
        };
        identifiers.push(universalIdentifier);
    }

    return identifiers;
};

public isolated function hdToUri(Hd hd) returns r4:uri? {
    if (hd.hd2 != "") {
        // HD.2 (Universal ID) with prefixing based on HD.3 (Universal ID Type)
        if (hd.hd3 == "ISO" || hd.hd3 == "UUID") {
            return string `urn:${(<string>hd.hd3).toLowerAscii()}:${hd.hd2}`;
        } else if (hd.hd3 == "DNS" || hd.hd3 == "URI") {
            return hd.hd2;
        } else {
            // Default to urn:oid: prefix if no specific type is specified
            return string `urn:oid:${hd.hd2}`;
        }
    } else if (hd.hd1 != "") {
        // HD.1 (Namespace ID) as fallback
        return hd.hd1;
    }
    return ();
};

public isolated function idToBoolean(Id id) returns boolean? {
    if (id == "") {
        return ();
    }
    
    // Common HL7 V2 boolean mappings
    // Y = true, N = false, and other common patterns
    string idValue = <string>id;
    if (idValue == "Y" || idValue == "YES" || idValue == "1" || idValue == "TRUE") {
        return true;
    } else if (idValue == "N" || idValue == "NO" || idValue == "0" || idValue == "FALSE") {
        return false;
    }
    
    // If the value doesn't match common boolean patterns, return null
    // as the mapping guide notes that vocabulary mapping is done at segment's field level
    return ();
};

public isolated function idToCode(Id id) returns r4:code? {
    // ID.1 maps to $value (the code value itself)
    // Note that vocabulary mapping is done at the segment's field level
    return (id != "") ? <r4:code>id : ();
};

public isolated function idToString(Id id) returns string? {
    // ID.1 maps to $value (the string value itself)
    return (id != "") ? <string>id : ();
};

public isolated function isToCodeableConcept(Is 'is) returns r4:CodeableConcept? {
    // IS.1 (Identifier) maps to coding.code
    r4:CodeableConcept codeableConcept = {
        coding: [
            {
                code: ('is != "") ? <r4:code>'is : ()
            }
        ]
    };
    return ('is != "") ? codeableConcept : ();
};

public isolated function isToCode(Is 'is) returns r4:code? {
    // IS.1 maps to $value (the code value itself)
    return ('is != "") ? <r4:code>'is : ();
};

public isolated function isToString(Is 'is) returns string? {
    // IS.1 maps to $value (the string value itself)
    return ('is != "") ? <string>'is : ();
};

public isolated function nmToQuantity(Nm nm) returns r4:Quantity? {
    // NM.1 (Numeric) maps to $value (the decimal value itself)
    decimal|error value = decimal:fromString(<string>nm);
    if value is decimal {
        return {
            value: value
        };
    }
    return ();
};

public isolated function nmToPositiveInt(Nm nm) returns int? {
    // NM.1 (Numeric) maps to $value (the positive integer value itself)
    int|error value = int:fromString(<string>nm);
    if value is int && value > 0 {
        return value;
    }
    return ();
};

