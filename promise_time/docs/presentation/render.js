const { chromium } = require('playwright');
(async () => {
  const [,, input, output] = process.argv;
  const b = await chromium.launch();
  const p = await b.newPage({ viewport: { width: 1920, height: 1080 } });
  await p.goto('file://' + input);
  await p.evaluate(() => document.fonts.ready);
  await p.waitForTimeout(500);
  await p.screenshot({ path: output });
  await b.close();
})();
