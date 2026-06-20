# Waveform Analysis

## Normal Traffic Operation

State sequence:

000 -> 001 -> 010 -> 011 -> 000

## Pedestrian Request

Sequence observed:

000 -> 001 -> 100 -> 101 -> 000

## Emergency Vehicle

When emergency_vehicle = 1

FSM immediately transitions to:

000 (NS Green)

## Verification Results

- Correct state transitions
- Correct timer operation
- Pedestrian walk functionality verified
- Emergency override verified