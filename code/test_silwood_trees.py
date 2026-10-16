"""Tests for the tree-survey cleaning functions."""

from clean_silwood_trees import (
    validate_record,
    process_records,
    summarise_oaks,
)


def make_record():
    """Return a new dictionary containing a valid record."""
    return {
        "record_id": "ST001",
        "location": "Silwood Bottom",
        "genus": "Quercus",
        "species": "robur",
        "distance_m": "12.5",
        "angle_degrees": "35",
    }


def test_text_cleaning():
    """Check whitespace removal and canonical capitalization."""
    row = make_record()
    row["record_id"] = " ST001 "
    row["location"] = " silwood bottom "
    row["genus"] = " QUERCUS "
    row["species"] = " ROBUR "

    clean, reasons = validate_record(row, 2, set())

    assert reasons == []
    assert clean is not None
    assert clean["record_id"] == "ST001"
    assert clean["location"] == "Silwood Bottom"
    assert clean["genus"] == "Quercus"
    assert clean["species"] == "robur"
    assert float(clean["distance_m"]) == 12.5
    assert float(clean["angle_degrees"]) == 35


def test_multiple_errors():
    """Check that all rejection reasons appear in the required order."""
    row = make_record()
    row["location"] = "Unknown Site"
    row["genus"] = ""
    row["distance_m"] = "forty"
    row["angle_degrees"] = "90"

    clean, reasons = validate_record(row, 2, set())

    assert clean is None
    assert reasons == [
        "invalid location",
        "missing genus",
        "invalid distance_m",
        "angle_degrees out of range",
    ]

def test_duplicate_ids():
    """Reject duplicates of accepted records."""
    first = make_record()
    second = make_record()

    clean, issues = process_records([first, second])

    assert len(clean) == 1
    assert issues == [{
        "source_row": "3",
        "record_id": "ST001",
        "reasons": "duplicate record_id",
    }]


def test_invalid_record_does_not_reserve_id():
    """Allow a valid record to reuse an ID from a rejected record."""
    first = make_record()
    first["distance_m"] = "-2"
    second = make_record()

    clean, issues = process_records([first, second])

    assert len(clean) == 1
    assert clean[0]["record_id"] == "ST001"
    assert issues == [{
        "source_row": "2",
        "record_id": "ST001",
        "reasons": "distance_m out of range",
    }]


def test_numeric_boundaries():
    """Check inclusive and exclusive measurement boundaries."""
    cases = [
        ("distance_m", "0", ["distance_m out of range"]),
        ("distance_m", "100", []),
        ("distance_m", "100.1", ["distance_m out of range"]),
        ("angle_degrees", "0", ["angle_degrees out of range"]),
        ("angle_degrees", "89.9", []),
        ("angle_degrees", "90", ["angle_degrees out of range"]),
    ]

    for field, value, expected_reasons in cases:
        row = make_record()
        row[field] = value

        clean, reasons = validate_record(row, 2, set())

        assert reasons == expected_reasons, (field, value, reasons)
        assert (clean is not None) == (expected_reasons == [])


def test_non_finite_numbers():
    """Reject NaN and infinity as invalid numeric values."""
    for field in ("distance_m", "angle_degrees"):
        for value in ("nan", "inf", "-inf"):
            row = make_record()
            row[field] = value

            clean, reasons = validate_record(row, 2, set())

            assert clean is None
            assert reasons == [f"invalid {field}"]
def test_missing_fields():
    """Reject each required field when it contains only whitespace."""
    for field in make_record():
        row = make_record()
        row[field] = "   "

        clean, reasons = validate_record(row, 2, set())

        assert clean is None
        assert reasons == [f"missing {field}"], (field, reasons)


def test_invalid_values():
    """Reject unrecognised values without guessing corrections."""
    cases = [
        ("record_id", "st001", "invalid record_id"),
        ("record_id", "ST12", "invalid record_id"),
        ("record_id", "ST1234", "invalid record_id"),
        ("location", "Old Orchard", "invalid location"),
        ("genus", "Quercuss", "invalid genus"),
        ("species", "roburr", "invalid species"),
        ("distance_m", "forty", "invalid distance_m"),
        ("angle_degrees", "forty", "invalid angle_degrees"),
    ]

    for field, value, expected in cases:
        row = make_record()
        row[field] = value

        clean, reasons = validate_record(row, 2, set())

        assert clean is None
        assert reasons == [expected], (field, value, reasons)


def test_taxon_combination():
    """Reject recognised genus and species values paired incorrectly."""
    row = make_record()
    row["species"] = "excelsior"

    clean, reasons = validate_record(row, 2, set())

    assert clean is None
    assert reasons == ["invalid genus/species combination"]


def test_oak_summary():
    """Count exact oak genera only and sort the species summary."""
    records = [
        {"genus": "Quercus", "species": "robur"},
        {"genus": "Quercus", "species": "petraea"},
        {"genus": "Quercus", "species": "robur"},
        {"genus": "Quercuss", "species": "robur"},
        {"genus": "Acer", "species": "pseudoplatanus"},
    ]

    assert summarise_oaks(records) == [
        {"species": "petraea", "count": "1"},
        {"species": "robur", "count": "2"},
    ]


def test_no_oaks():
    """Return an empty summary when no oak records are present."""
    records = [{"genus": "Acer", "species": "pseudoplatanus"}]

    assert summarise_oaks(records) == []
    assert summarise_oaks([]) == []
if __name__ == "__main__":
    test_text_cleaning()
    test_multiple_errors()
    test_duplicate_ids()
    test_invalid_record_does_not_reserve_id()
    test_numeric_boundaries()
    test_non_finite_numbers()
    test_missing_fields()
    test_invalid_values()
    test_taxon_combination()
    test_oak_summary()
    test_no_oaks()
    print("All tests passed.")