import express from "express";
import ascLogo from "./asc-logo";

const app = express();

app.get("/", (_, res) => res.send(ascLogo));

export default app;
