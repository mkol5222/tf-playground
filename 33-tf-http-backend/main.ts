// via https://deno.com/blog/build-crud-api-oak-denokv

import { existsSync } from "https://deno.land/std/fs/mod.ts";

const STATE_FILE = "server.tfstate";
const LOCK_FILE = `${STATE_FILE}.lock`;

import {
    Application,
    Context,
    helpers,
    Router,
} from "https://deno.land/x/oak@v12.6.2/mod.ts";

const { getQuery } = helpers;
const router = new Router({
    methods: [
        "GET",
        "POST",
        "LOCK",
        "UNLOCK"
    ]
});

router
    .get("/tfstate", async (ctx: Context) => {
        ctx.response.body = {};
    })
    .get("/tfstate/:id", async (ctx: Context) => {
        const { id } = getQuery(ctx, { mergeParams: true });

        console.log("GET", id);

        try {
            const text = await Deno.readTextFile(STATE_FILE);
            ctx.response.body = text;
        } catch (err) {
            console.error(err);
        }
    })
    .post("/tfstate/:id", async (ctx: Context) => {
        const { id } = getQuery(ctx, { mergeParams: true });
        console.log("POST", id, ctx.request.url.href);

        try {
            const result = await ctx.request.body({ type: "json" }).value;
            await Deno.writeTextFile(STATE_FILE, JSON.stringify(result, null, 2));

            ctx.response.body = {};
        } catch (err) {
            console.error(err);
        }
    })

router.add("LOCK", "/tfstate/:id", async (ctx: Context) => {
    const { id } = getQuery(ctx, { mergeParams: true });
    console.log("LOCK", id);

    try {
        if (existsSync(LOCK_FILE)) {
            // return ("State already locked", 423)
            ctx.response.status = 423;
            ctx.response.body = "State already locked";
        } else {
            await Deno.writeTextFile(LOCK_FILE, "");
            ctx.response.status = 200;
            ctx.response.body = "State locked";
        }
    } catch (err) {
        console.error(err);
    }
});

router.add("UNLOCK", "/tfstate/:id", async (ctx: Context) => {
    const { id } = getQuery(ctx, { mergeParams: true });
    console.log("UNLOCK", id);
    try {
        await Deno.remove(LOCK_FILE);
        // return ("State unlocked", 200)
        ctx.response.status = 200;
        ctx.response.body = "State unlocked";
        return;
    } catch (err) {
        console.error(err);
        //  return ("State already unlocked", 409)
        ctx.response.status = 409;
        ctx.response.body = "State already unlocked";
    }
});

const app = new Application();

app.use(router.routes());
app.use(router.allowedMethods());

await app.listen({ port: 8000 });
