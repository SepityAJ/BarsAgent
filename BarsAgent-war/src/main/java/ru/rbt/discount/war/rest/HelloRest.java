package ru.rbt.discount.war.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by KryukovMV on 13.03.2017.
 */
@Path("/hello-rest")
@Produces("text/plain")
public class HelloRest {

    @GET
    public String hello() {
        return "Hello!";
    }

}
