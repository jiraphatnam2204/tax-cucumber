Feature: Thai Income Tax Calculation
  Calculate progressive income tax across all 9 tax brackets

  # Bracket 1: 0%  — taxable income 0 – 150,000
  Scenario: Income taxed entirely in the 0% bracket
    Given a gross income of 200000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 140000
    And tax should be 0.0

  # Bracket 2: 5%  — taxable income 150,001 – 300,000
  Scenario: Income taxed up to the 5% bracket
    Given a gross income of 300000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 240000
    And tax should be 4500.0

  # Bracket 3: 10% — taxable income 300,001 – 500,000
  Scenario: Income taxed up to the 10% bracket
    Given a gross income of 500000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 440000
    And tax should be 21500.0

  # Bracket 4: 15% — taxable income 500,001 – 750,000
  Scenario: Income taxed up to the 15% bracket
    Given a gross income of 700000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 640000
    And tax should be 48500.0

  # Bracket 5: 20% — taxable income 750,001 – 1,000,000
  Scenario: Income taxed up to the 20% bracket
    Given a gross income of 900000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 840000
    And tax should be 83000.0

  # Bracket 6: 25% — taxable income 1,000,001 – 2,000,000
  Scenario: Income taxed up to the 25% bracket
    Given a gross income of 1500000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 1440000
    And tax should be 225000.0

  # Bracket 7: 30% — taxable income 2,000,001 – 5,000,000
  Scenario: Income taxed up to the 30% bracket
    Given a gross income of 3000000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 2940000
    And tax should be 647000.0

  # Bracket 8: 35% — taxable income 5,000,001 – 10,000,000
  Scenario: Income taxed up to the 35% bracket
    Given a gross income of 7000000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 6940000
    And tax should be 1944000.0

  # Bracket 9: 37% — taxable income above 10,000,000
  Scenario: Income taxed up to the 37% bracket
    Given a gross income of 12000000
    And deductions:
      | personal | 60000 |
    When I calculate tax
    Then the taxable income should be 11940000
    And tax should be 3732800.0
