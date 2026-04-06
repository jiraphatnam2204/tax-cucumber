// cli.js — Interactive CLI for Thai income tax calculator
const readline = require('readline');
const { calculateTax } = require('./taxCalculator');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function ask(question) {
  return new Promise((resolve) => rl.question(question, (ans) => resolve(ans.trim())));
}

function parseNumber(input, defaultValue = 0) {
  const n = parseFloat(input.replace(/,/g, ''));
  return isNaN(n) ? defaultValue : n;
}

function formatMoney(n) {
  return n.toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

async function main() {
  console.log('\n========================================');
  console.log('   Thai Income Tax Calculator (CLI)');
  console.log('========================================\n');

  // --- Income ---
  const incomeInput = await ask('Gross annual income (THB): ');
  const grossIncome = parseNumber(incomeInput);

  if (grossIncome <= 0) {
    console.log('\nIncome must be greater than 0. Exiting.');
    rl.close();
    return;
  }

  console.log('\n--- Deductions ---');
  console.log('(Press Enter to use the default value shown in brackets)\n');

  // Personal allowance
  const personalInput = await ask('Personal allowance [default: 60,000]: ');
  const personal = personalInput === '' ? 60000 : parseNumber(personalInput, 60000);

  // Children
  const childCountInput = await ask('Number of children [default: 0]: ');
  const childrenCount = parseNumber(childCountInput, 0);
  let perChild = 0;
  if (childrenCount > 0) {
    const perChildInput = await ask('Deduction per child [default: 30,000]: ');
    perChild = perChildInput === '' ? 30000 : parseNumber(perChildInput, 30000);
  }

  // Parents
  const parentCountInput = await ask('Number of parents supported [default: 0]: ');
  const parentsCount = parseNumber(parentCountInput, 0);
  let perParent = 0;
  if (parentsCount > 0) {
    const perParentInput = await ask('Deduction per parent [default: 30,000]: ');
    perParent = perParentInput === '' ? 30000 : parseNumber(perParentInput, 30000);
  }

  // Other deductions
  const otherInput = await ask('Other deductions (e.g. SSF, RMF, donations) [default: 0]: ');
  const other = parseNumber(otherInput, 0);

  rl.close();

  // --- Calculate ---
  const deductions = {
    personal,
    children: { count: childrenCount, perChild },
    parents: { count: parentsCount, perParent },
    other,
  };

  const result = calculateTax(grossIncome, deductions);

  // --- Display result ---
  console.log('\n========================================');
  console.log('           Tax Calculation Result');
  console.log('========================================');
  console.log(`Gross Income       : ฿${formatMoney(result.grossIncome)}`);
  console.log(`Total Deductions   : ฿${formatMoney(result.totalDeductions)}`);
  console.log(`  - Personal       : ฿${formatMoney(personal)}`);
  if (childrenCount > 0)
    console.log(`  - Children (${childrenCount}x)  : ฿${formatMoney(childrenCount * perChild)}`);
  if (parentsCount > 0)
    console.log(`  - Parents  (${parentsCount}x)  : ฿${formatMoney(parentsCount * perParent)}`);
  if (other > 0)
    console.log(`  - Other          : ฿${formatMoney(other)}`);
  console.log(`Taxable Income     : ฿${formatMoney(result.taxableIncome)}`);
  console.log('----------------------------------------');
  console.log(`Tax Owed           : ฿${formatMoney(result.tax)}`);
  console.log(`Effective Tax Rate : ${(result.effectiveRate * 100).toFixed(2)}%`);
  console.log('========================================\n');
}

main().catch((err) => {
  console.error('Error:', err.message);
  rl.close();
  process.exit(1);
});
