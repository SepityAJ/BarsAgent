package ru.rbt.discount.war.rest.interceptor;

import ru.rbt.discount.war.api.Secured;

import javax.annotation.Priority;
import javax.inject.Inject;
import javax.security.auth.Subject;
import javax.ws.rs.Priorities;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.core.SecurityContext;
import javax.ws.rs.ext.Provider;
import java.io.IOException;
import java.security.Principal;

/**
 * Created by KryukovMV on 24.03.2017.
 */

@Secured
@Provider
@Priority(Priorities.AUTHENTICATION)
public class SecurityFilter implements ContainerRequestFilter {

//    @Inject
//    private SecurityManager securityManager;

    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
        //TODO
        final SecurityContext currentSecurityContext = requestContext.getSecurityContext();
        requestContext.setSecurityContext(new SecurityContext() {

            @Override
            public Principal getUserPrincipal() {
                if (checkDigest()) {
                    return new Principal() {
                        @Override
                        public String getName() {
                            return null;
                        }
                        @Override
                        public boolean implies(Subject subject) {
                            return false;
                        }
                    };
                } else {
                    return null;
                }
            }

            @Override
            public boolean isUserInRole(String roleName) {
                return checkDigest();
            }

            @Override
            public boolean isSecure() {
                return currentSecurityContext.isSecure();
            }

            @Override
            public String getAuthenticationScheme() {
                return "Bearer";
            }
        });
    }

    private boolean checkDigest() {
        return true;
    }

}
