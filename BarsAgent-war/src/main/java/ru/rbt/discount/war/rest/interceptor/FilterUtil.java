package ru.rbt.discount.war.rest.interceptor;

import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.core.Cookie;

/**
 * Created by KryukovMV on 27.03.2017.
 */
public class FilterUtil {

    static String getToken(ContainerRequestContext requestContext) {
        for (Cookie cookie : requestContext.getCookies().values()) {
            if (cookie.getName().equals("my-spec-token")) {
                return cookie.getValue();
            }
        }
        return null;
    }
}
