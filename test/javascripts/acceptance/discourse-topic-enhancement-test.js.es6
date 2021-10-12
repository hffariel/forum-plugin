import { acceptance } from "helpers/qunit-helpers";

acceptance("StarRocksPlugin", { loggedIn: true });

test("StarRocksPlugin works", async assert => {
  await visit("/admin/plugins/starrocks-plugin");

  assert.ok(false, "it shows the StarRocksPlugin button");
});
