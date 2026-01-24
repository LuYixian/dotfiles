#!/usr/bin/env node
// fetch-provider-docs.js - Fetch JS-rendered documentation pages using Playwright
// Usage: node fetch-provider-docs.js [provider|all]

const { chromium } = require("playwright");

const PROVIDER_DOCS = {
  deepseek: "https://api-docs.deepseek.com/guides/anthropic_api",
  kimi: "https://platform.moonshot.cn/docs/guide/agent-support",
  glm: "https://docs.bigmodel.cn/cn/coding-plan/tool/claude",
  qwen: "https://help.aliyun.com/zh/model-studio/claude-code",
  minimax: "https://platform.minimax.io/docs/coding-plan/claude-code",
  doubao: "https://www.volcengine.com/docs/82379/1928261",
};

async function fetchPage(url, timeout = 30000) {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    await page.goto(url, { waitUntil: "networkidle", timeout });
    await page.waitForTimeout(2000);
    const content = await page.evaluate(() => {
      const clone = document.body.cloneNode(true);
      clone
        .querySelectorAll("script, style, noscript")
        .forEach((el) => el.remove());
      return clone.innerText;
    });
    return content;
  } finally {
    await browser.close();
  }
}

async function main() {
  const provider = process.argv[2] || "all";
  const providers =
    provider === "all" ? Object.keys(PROVIDER_DOCS) : [provider];

  const results = {};

  for (const p of providers) {
    const url = PROVIDER_DOCS[p];
    if (!url) {
      console.error(`Unknown provider: ${p}`);
      continue;
    }

    console.error(`Fetching ${p}...`);
    try {
      const content = await fetchPage(url);
      results[p] = { url, content: content.slice(0, 15000) };
      console.error(`  ✓ ${p}: ${content.length} chars`);
    } catch (error) {
      console.error(`  ✗ ${p}: ${error.message}`);
      results[p] = { url, error: error.message };
    }
  }

  console.log(JSON.stringify(results, null, 2));
}

main().catch(console.error);
