# FSM Design

## State Encoding

| State | Binary | Description |
|---------|---------|---------|
| S0 | 000 | NS Green |
| S1 | 001 | NS Yellow |
| S2 | 010 | EW Green |
| S3 | 011 | EW Yellow |
| S4 | 100 | All Red |
| S5 | 101 | Pedestrian Walk |

## State Flow

S0 -> S1 -> S2 -> S3 -> S0

Pedestrian Request:

S0/S2
   ↓
Yellow
   ↓
All Red
   ↓
Pedestrian Walk
   ↓
Normal Traffic

Emergency Vehicle:

Any State
   ↓
S0 (NS Green)