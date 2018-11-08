import express from "express";
import morgan from "morgan";
import { fn } from ".";

const app = express();

// https://github.com/expressjs/morgan#dev
// :method :url :status :response-time ms - :res[content-length]
app.use(morgan("dev"));

app.use("/", fn);

if (typeof jest === "undefined") {
  app.listen(3000, () => {
    console.log(Date(), "Functions server is up and running");
  });
}

export default app;
