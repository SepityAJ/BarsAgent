package ru.rbt.discount.war.rest.interceptor;

import ru.rbt.discount.war.api.Audited;

import javax.annotation.Priority;
import javax.inject.Inject;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.ext.Provider;
import java.io.IOException;

/**
 * Created by KryukovMV on 24.03.2017.
 */

@Audited
@Provider
@Priority(100)
public class AuditFilter implements ContainerRequestFilter {

//    @Inject
//    private SecurityManager securityManager;

    @Override
    public void filter(ContainerRequestContext context) throws IOException {
        UriInfo uriInfo = context.getUriInfo();
//        User user = securityManager.getSessionUser(FilterUtil.getToken(context));
//        securityManager.toJournal(Auditor.access(context.getUriInfo().getPath()), user,
//                Auditor.makeAuditParameters(user, context));
    }

}
