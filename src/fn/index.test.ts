import supertest from "supertest";
import { default as app } from ".";
import ascLogo from "./asc-logo";

test("GET /", done => {
  supertest(app)
    .get("/")
    .expect(200, ascLogo)
    .end(done);
});
