#!/usr/bin/env python3
"""Validate and clean the synthetic Silwood tree survey."""

from __future__ import annotations

import csv
import re
import math
from pathlib import Path
from typing import Iterable


PROJECT_ROOT = Path(__file__).resolve().parents[1]
INPUT_PATH = PROJECT_ROOT / "data" / "silwood_trees_raw.csv"
RESULTS_DIR = PROJECT_ROOT / "results"

INPUT_FIELDS = [
    "record_id",
    "location",
    "genus",
    "species",
    "distance_m",
    "angle_degrees",
]
ISSUE_FIELDS = ["source_row", "record_id", "reasons"]
OAK_COUNT_FIELDS = ["species", "count"]


def load_records(path: Path = INPUT_PATH) -> list[dict[str, str]]:
    """Read the survey and check its column names."""
    with path.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source)
        if reader.fieldnames != INPUT_FIELDS:
            raise ValueError(
                f"Expected columns {INPUT_FIELDS}, found {reader.fieldnames}"
            )
        return list(reader)


def validate_record(
    row: dict[str, str],
    source_row: int,
    accepted_ids: set[str],
) -> tuple[dict[str, str] | None, list[str]]:
    """Clean one record, or return the reasons it cannot be used."""
    reasons = []
    record_id = row["record_id"].strip()

    
    if not record_id:
        reasons.append("missing record_id")
    elif re.fullmatch(r"ST[0-9]{3}", record_id) is None:
        reasons.append("invalid record_id")

    
    if record_id in accepted_ids:
        reasons.append("duplicate record_id")

    locations = {
        "silwood bottom": "Silwood Bottom",
        "nash's field": "Nash's Field",
        "manor house": "Manor House",
        "reactor wood": "Reactor Wood",
    }

    location = row["location"].strip()
    canonical_location = locations.get(location.lower())

    if not location:
        reasons.append("missing location")
    elif canonical_location is None:
        reasons.append("invalid location")
    genera = {
        "quercus": "Quercus",
        "acer": "Acer",
        "betula": "Betula",
        "fagus": "Fagus",
        "fraxinus": "Fraxinus",
    }

    
    allowed_pairs = {
        ("Quercus", "robur"),
        ("Quercus", "petraea"),
        ("Acer", "pseudoplatanus"),
        ("Betula", "pendula"),
        ("Fagus", "sylvatica"),
        ("Fraxinus", "excelsior"),
    }
    allowed_species = {pair[1] for pair in allowed_pairs}

    genus = row["genus"].strip()
    species = row["species"].strip()

    canonical_genus = genera.get(genus.lower())
    canonical_species = species.lower()

    
    if not genus:
        reasons.append("missing genus")
    elif canonical_genus is None:
        reasons.append("invalid genus")

    if not species:
        reasons.append("missing species")
    elif canonical_species not in allowed_species:
        reasons.append("invalid species")

    
    if (
        canonical_genus is not None
        and canonical_species in allowed_species
        and (canonical_genus, canonical_species) not in allowed_pairs
    ):
        reasons.append("invalid genus/species combination")
    distance_text = row["distance_m"].strip()
    distance = None

    if not distance_text:
        reasons.append("missing distance_m")
    else:
        try:
            distance = float(distance_text)
        except ValueError:
            reasons.append("invalid distance_m")
        else:
            if not math.isfinite(distance):
                reasons.append("invalid distance_m")
            elif not (0 < distance <= 100):
                reasons.append("distance_m out of range")

    
    angle_text = row["angle_degrees"].strip()
    angle = None

    if not angle_text:
        reasons.append("missing angle_degrees")
    else:
        try:
            angle = float(angle_text)
        except ValueError:
            reasons.append("invalid angle_degrees")
        else:
            if not math.isfinite(angle):
                reasons.append("invalid angle_degrees")
            elif not (0 < angle < 90):
                reasons.append("angle_degrees out of range")
        
    if reasons:
        return None, reasons

    
    clean_record = {
        "record_id": record_id,
        "location": canonical_location,
        "genus": canonical_genus,
        "species": canonical_species,
        "distance_m": str(distance),
        "angle_degrees": str(angle),
    }
    return clean_record, []
    
    



def process_records(
    rows: Iterable[dict[str, str]],
) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    """Sort records into accepted rows and issue reports."""
    clean_records = []
    issues = []
    accepted_ids = set()

   
    for source_row, row in enumerate(rows, start=2):
        clean_record, reasons = validate_record(
            row, source_row, accepted_ids
        )

        if reasons:
            issues.append({
                "source_row": str(source_row),
                "record_id": row["record_id"].strip(),
                "reasons": "; ".join(reasons),
            })
        else:
            clean_records.append(clean_record)

            
            accepted_ids.add(clean_record["record_id"])

    
    clean_records.sort(key=lambda record: record["record_id"])

    return clean_records, issues

def summarise_oaks(clean_records: Iterable[dict[str, str]]) -> list[dict[str, str]]:
    """Count accepted oak records by species."""
    


    counts = {}

    for record in clean_records:
        if record["genus"] == "Quercus":
            species = record["species"]
            counts[species] = counts.get(species, 0) + 1

    
    summary = []
    for species in sorted(counts):
        summary.append({
            "species": species,
            "count": str(counts[species]),
        })

    return summary

def write_csv(
    path: Path,
    fieldnames: list[str],
    rows: Iterable[dict[str, str]],
) -> None:
    """Write rows to a CSV file, replacing an older copy."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as destination:
        writer = csv.DictWriter(destination, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    """Clean the survey and write the three result files."""
    clean_records, issues = process_records(load_records())
    oak_counts = summarise_oaks(clean_records)

    write_csv(
        RESULTS_DIR / "silwood_trees_clean.csv",
        INPUT_FIELDS,
        clean_records,
    )
    write_csv(
        RESULTS_DIR / "silwood_tree_issues.csv",
        ISSUE_FIELDS,
        issues,
    )
    write_csv(
        RESULTS_DIR / "oak_species_counts.csv",
        OAK_COUNT_FIELDS,
        oak_counts,
    )


if __name__ == "__main__":
    main()
