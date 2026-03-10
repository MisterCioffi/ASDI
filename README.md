# ASDI — Architettura dei Sistemi Digitali

Repository contenente tutti gli esercizi svolti per il corso di **Architettura dei Sistemi Digitali (ASDI)**, organizzati per capitoli tematici. I progetti sono sviluppati in **VHDL** e gestiti tramite **Xilinx Vivado**.

---

## Struttura della Repository

### Esercizi

Gli esercizi sono suddivisi nelle seguenti sezioni, ciascuna corrispondente a un capitolo del programma:

| Cartella | Argomento |
|---|---|
| `Esercizi_Reti_Elementari` | Reti combinatorie elementari (mux, demux, reti logiche) |
| `Esercizi_Reti_Sequenziali_Elementari` | Reti sequenziali elementari (contatori, shift register, cronometri, sistemi PO/PC) |
| `Esercizi_Macchine_Aritmetiche` | Macchine aritmetiche (moltiplicatore di Booth) |
| `Esercizi_Handshaking` | Protocolli di handshaking |
| `Esercizi_Interfaccia_Seriale` | Interfacce seriali |
| `Esercizi_SwitchMultistadio` | Switch multistadio |
| `Esercizi_Sistema_Complesso` | Sistemi complessi |

Ogni esercizio è contenuto in una sottocartella dedicata con il relativo progetto Vivado (`.xpr`) e i file sorgente VHDL.

### Appendice

La cartella `Appendice/` raccoglie i **componenti VHDL riutilizzabili**, ovvero moduli che vengono istanziati frequentemente all'interno dei vari esercizi:

| File | Descrizione |
|---|---|
| `Button_Conditioner.vhd` | Condizionamento del segnale di un pulsante (debouncing) |
| `FFD.vhd` | Flip-Flop D |
| `mux_2_1.vhd` | Multiplexer 2 a 1 |
| `mux_4_1.vhd` | Multiplexer 4 a 1 |
| `demux_8_1.vhd` | Demultiplexer 8 a 1 |
| `cont_mod2.vhd` | Contatore modulo 2 |
| `cont_mod2_load.vhd` | Contatore modulo 2 con load |
| `cont_mod_24_load.vhd` | Contatore modulo 24 con load |
| `cont.mod60_load.vhd` | Contatore modulo 60 con load |
| `ROM_16_8.vhd` | ROM 16×8 |

---

## Strumenti Utilizzati

- **Linguaggio:** VHDL
- **IDE:** Xilinx Vivado
- **Target:** FPGA (Nexys A7 50T)
