Feature: Thai Income Tax Calculation
  As a Thai taxpayer,
  I want to calculate my income tax correctly,
  So that I know the exact amount I owe based on progressive brackets and deductions.

  # =============================================================================
  # Thai Progressive Tax Brackets (2024)
  # -----------------------------------------------------------------------------
  #   Bracket |  Taxable Income Range     |  Rate
  #   --------|---------------------------|-------
  #      1    |        0 –    150,000     |   0%
  #      2    |  150,001 –    300,000     |   5%
  #      3    |  300,001 –    500,000     |  10%
  #      4    |  500,001 –    750,000     |  15%
  #      5    |  750,001 –  1,000,000     |  20%
  #      6    |  1,000,001 – 2,000,000    |  25%
  #      7    |  2,000,001 – 5,000,000    |  30%
  #      8    |  5,000,001 – 10,000,000   |  35%
  #      9    |  Above 10,000,000         |  37%
  # =============================================================================
  #
  # Deduction Rates Used in Tests
  # -----------------------------------------------------------------------------
  #   Type              |  Amount
  #   ------------------|------------------
  #   Personal          |  60,000 THB
  #   Per child         |  30,000 THB
  #   Per parent        |  30,000 THB
  # =============================================================================

  # ---------------------------------------------------------------------------
  # SECTION 1: Progressive Tax Bracket Coverage
  # ---------------------------------------------------------------------------
  # Each scenario uses only the personal deduction (60,000) to isolate
  # bracket behavior. Gross income is chosen so that the taxable income
  # falls within the target bracket.
  # ---------------------------------------------------------------------------

  # Taxable = 200,000 - 60,000 = 140,000 → falls entirely in bracket 1
  # Tax = 0
  Scenario: Bracket 1 — 0% on taxable income 0 – 150,000
    Given a gross income of 200000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 140000
    And tax should be 0.0

  # Taxable = 300,000 - 60,000 = 240,000 → enters bracket 2
  # Tax = 0 + (240,000 - 150,000) × 5% = 4,500
  Scenario: Bracket 2 — 5% on taxable income 150,001 – 300,000
    Given a gross income of 300000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 240000
    And tax should be 4500.0

  # Taxable = 500,000 - 60,000 = 440,000 → enters bracket 3
  # Tax = 0 + 7,500 + (440,000 - 300,000) × 10% = 21,500
  Scenario: Bracket 3 — 10% on taxable income 300,001 – 500,000
    Given a gross income of 500000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 440000
    And tax should be 21500.0

  # Taxable = 700,000 - 60,000 = 640,000 → enters bracket 4
  # Tax = 0 + 7,500 + 20,000 + (640,000 - 500,000) × 15% = 48,500
  Scenario: Bracket 4 — 15% on taxable income 500,001 – 750,000
    Given a gross income of 700000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 640000
    And tax should be 48500.0

  # Taxable = 900,000 - 60,000 = 840,000 → enters bracket 5
  # Tax = 0 + 7,500 + 20,000 + 37,500 + (840,000 - 750,000) × 20% = 83,000
  Scenario: Bracket 5 — 20% on taxable income 750,001 – 1,000,000
    Given a gross income of 900000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 840000
    And tax should be 83000.0

  # Taxable = 1,500,000 - 60,000 = 1,440,000 → enters bracket 6
  # Tax = 0 + 7,500 + 20,000 + 37,500 + 50,000 + (1,440,000 - 1,000,000) × 25% = 225,000
  Scenario: Bracket 6 — 25% on taxable income 1,000,001 – 2,000,000
    Given a gross income of 1500000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 1440000
    And tax should be 225000.0

  # Taxable = 3,000,000 - 60,000 = 2,940,000 → enters bracket 7
  # Tax = 0 + 7,500 + 20,000 + 37,500 + 50,000 + 250,000
  #      + (2,940,000 - 2,000,000) × 30% = 647,000
  Scenario: Bracket 7 — 30% on taxable income 2,000,001 – 5,000,000
    Given a gross income of 3000000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 2940000
    And tax should be 647000.0

  # Taxable = 7,000,000 - 60,000 = 6,940,000 → enters bracket 8
  # Tax = 0 + 7,500 + 20,000 + 37,500 + 50,000 + 250,000 + 900,000
  #      + (6,940,000 - 5,000,000) × 35% = 1,944,000
  Scenario: Bracket 8 — 35% on taxable income 5,000,001 – 10,000,000
    Given a gross income of 7000000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 6940000
    And tax should be 1944000.0

  # Taxable = 12,000,000 - 60,000 = 11,940,000 → enters bracket 9
  # Tax = 0 + 7,500 + 20,000 + 37,500 + 50,000 + 250,000 + 900,000
  #      + 1,750,000 + (11,940,000 - 10,000,000) × 37% = 3,732,800
  Scenario: Bracket 9 — 37% on taxable income above 10,000,000
    Given a gross income of 12000000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 11940000
    And tax should be 3732800.0

  # ---------------------------------------------------------------------------
  # SECTION 2: Deduction Combinations
  # ---------------------------------------------------------------------------
  # All scenarios use the same gross income (500,000) to isolate the effect
  # of different deduction combinations on taxable income and tax.
  #
  # Formula: taxable income = gross income - total deductions
  # Tax is then calculated using the progressive brackets above.
  # ---------------------------------------------------------------------------

  # Deductions = 1 × 30,000 = 30,000
  # Taxable = 500,000 - 30,000 = 470,000
  # Tax = 0 + 7,500 + (470,000 - 300,000) × 10% = 24,500
  Scenario: Deduction — only 1 child (no personal allowance)
    Given a gross income of 500000
    And deductions:
      | children_count | 1     |
      | children_per   | 30000 |
    When I calculate tax
    Then the taxable income should be 470000
    And tax should be 24500.0

  # Deductions = 2 × 30,000 = 60,000
  # Taxable = 500,000 - 60,000 = 440,000
  # Tax = 0 + 7,500 + (440,000 - 300,000) × 10% = 21,500
  Scenario: Deduction — only 2 parents (no personal allowance)
    Given a gross income of 500000
    And deductions:
      | parents_count | 2     |
      | parents_per   | 30000 |
    When I calculate tax
    Then the taxable income should be 440000
    And tax should be 21500.0

  # Deductions = 60,000 + (1 × 30,000) = 90,000
  # Taxable = 500,000 - 90,000 = 410,000
  # Tax = 0 + 7,500 + (410,000 - 300,000) × 10% = 18,500
  Scenario: Deduction — personal + 1 child
    Given a gross income of 500000
    And deductions:
      | personal       | 60000 |
      | children_count | 1     |
      | children_per   | 30000 |
    When I calculate tax
    Then the taxable income should be 410000
    And tax should be 18500.0

  # Deductions = 60,000 + (2 × 30,000) = 120,000
  # Taxable = 500,000 - 120,000 = 380,000
  # Tax = 0 + 7,500 + (380,000 - 300,000) × 10% = 15,500
  Scenario: Deduction — personal + 2 parents
    Given a gross income of 500000
    And deductions:
      | personal      | 60000 |
      | parents_count | 2     |
      | parents_per   | 30000 |
    When I calculate tax
    Then the taxable income should be 380000
    And tax should be 15500.0

  # Deductions = (1 × 30,000) + (2 × 30,000) = 90,000
  # Taxable = 500,000 - 90,000 = 410,000
  # Tax = 0 + 7,500 + (410,000 - 300,000) × 10% = 18,500
  Scenario: Deduction — 1 child + 2 parents (no personal allowance)
    Given a gross income of 500000
    And deductions:
      | children_count | 1     |
      | children_per   | 30000 |
      | parents_count  | 2     |
      | parents_per    | 30000 |
    When I calculate tax
    Then the taxable income should be 410000
    And tax should be 18500.0

  # Deductions = 60,000 + (1 × 30,000) + (2 × 30,000) = 150,000
  # Taxable = 500,000 - 150,000 = 350,000
  # Tax = 0 + 7,500 + (350,000 - 300,000) × 10% = 12,500
  Scenario: Deduction — personal + 1 child + 2 parents (all deductions)
    Given a gross income of 500000
    And deductions:
      | personal       | 60000 |
      | children_count | 1     |
      | children_per   | 30000 |
      | parents_count  | 2     |
      | parents_per    | 30000 |
    When I calculate tax
    Then the taxable income should be 350000
    And tax should be 12500.0

