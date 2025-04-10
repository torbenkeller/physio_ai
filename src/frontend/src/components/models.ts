// Implement the methods
import type {PatientDto} from "../client";

export class Patient implements PatientDto {
    id: string;
    titel?: string;
    vorname: string;
    nachname: string;
    strasse?: string;
    hausnummer?: string;
    plz?: string;
    stadt?: string;
    telMobil?: string;
    telFestnetz?: string;
    email?: string;
    geburtstag?: string;

    constructor(patient: PatientDto) {
        this.id = patient.id;
        this.titel = patient.titel;
        this.vorname = patient.vorname;
        this.nachname = patient.nachname;
        this.strasse = patient.strasse;
        this.hausnummer = patient.hausnummer;
        this.plz = patient.plz;
        this.stadt = patient.stadt;
        this.telMobil = patient.telMobil;
        this.telFestnetz = patient.telFestnetz;
        this.email = patient.email;
        this.geburtstag = patient.geburtstag;
    }

    getFullName(): string {
        return [this.titel, this.vorname, this.nachname].join(" ");
    }

    getAddress(): string | null {
        if (!this.strasse && !this.hausnummer && !this.plz && !this.stadt) {
            return null;
        }

        return [
            [this.strasse, this.hausnummer].join(" "),
            [this.plz, this.stadt].join(" ")
        ].join("\n")
    }
}