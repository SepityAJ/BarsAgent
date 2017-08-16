package ru.rbt.discount.war.rest.util;

import org.apache.log4j.Logger;

import javax.ws.rs.core.Cookie;
import javax.ws.rs.core.NewCookie;
import javax.ws.rs.core.Response;
import java.net.URI;

/**
 * Created by misha on 31.03.17.
 */
public class ResponseRedirector {

    private static final Logger logger = Logger.getLogger(ResponseRedirector.class);

    public static Response redirectFromPostToGet(String path, String sessionKey) {
        try {
            return sessionKey == null
                    ? Response.seeOther(new URI(path)).build()
                    : Response.seeOther(new URI(path)).cookie(newCookie(sessionKey)).build();
        } catch (Exception ex) {
            logger.warn(ex.getMessage());
            return Response.serverError().build();
        }
    }


    public static Response redirect(String alias, String currentLink) {
        String uri = alias == null ? currentLink : currentLink + "/" + alias;
        return redirect(uri);
    }


    public static Response redirectHome() {
        return redirect("/");
    }

    private static Response redirect(String uri) {
        try {
            return Response.temporaryRedirect(new URI(uri)).build();
        } catch (Exception ex) {
            logException(ex, uri);
        }
        return Response.serverError().build();
    }

    private static synchronized void logException(Exception ex, String uri) {
        logger.warn("While redirecting to [" + uri + "] exception occurred: " + ex.getMessage());
    }

    private static NewCookie newCookie(String sessionKey) {
        return new NewCookie(new Cookie("dxtoken", sessionKey), "dxtoken", 60*30, false);
    }

    private static NewCookie disableCookie() {
        return new NewCookie(new Cookie("dxtoken", ""), "dxtoken", 0, false);
    }

}
