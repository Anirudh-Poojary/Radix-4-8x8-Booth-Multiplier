# Radix-4 8×8 Signed Booth Multiplier — RTL to GDS Flow

##  Project Overview

This project implements a **Radix-4 Booth encoded 8×8 signed multiplier**, taken through a complete **RTL-to-GDSII design flow**.
The design focuses on architectural efficiency, reduced partial products, and realistic post-layout timing analysis.

The multiplier supports **two’s complement signed multiplication** and is implemented as a **purely combinational datapath**, making it suitable for accurate critical-path evaluation.

---

##  Architecture Highlights

* **Radix-4 Modified Booth Encoding**

  * Reduces partial products by ~50% compared to radix-2
* **Signed multiplication**

  * Full support for two’s complement operands
* **Partial product generation**

  * Booth recoding with sign extension handling
* **Adder structure**

  * No clock, no registers (datapath-focused)

---

##  Tools & Technology

| Stage                   | Tool                                     |
| ----------------------- | ---------------------------------------- |
| RTL Design & Simulation | NClaunch                                 |
| Synthesis               | Cadence Genus                            |
| Floorplanning & P&R     | Cadence Innovus                          |
| Physical Verification   | DRC / LVS                                |
| Target Technology       | GPDK090                                  |

---

##  Results Summary

| Metric           | Observation                        |
| ---------------- | ---------------------------------- |
| Partial Products | Reduced using Radix-4 Booth        |
| Design Style     | Fully combinational                |
| Timing           | Evaluated post-route               |
| LVS              | Clean (filler mismatches excluded) |
| GDS              | Successfully generated             |

---

##  Key Learnings

* Importance of **architecture-level optimization** over brute-force sizing
* Why **post-layout timing** is the only realistic performance metric
* Practical challenges in **signed arithmetic and sign extension**
* Real ASIC flow issues like routing-induced delay and filler cells

---

##  Future Enhancements

* Register insertion for pipelined version
* Comparison with Wallace / Dadda multipliers
* Power analysis with switching activity
* Custom standard-cell adder integration

---


