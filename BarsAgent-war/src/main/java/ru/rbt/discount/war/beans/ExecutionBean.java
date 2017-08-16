package ru.rbt.discount.war.beans;

import javax.enterprise.context.ApplicationScoped;
import java.io.IOException;

/**
 * Created by er22317 on 16.08.2017.
 */
public class ExecutionBean {
    public void exec(String cmd) throws IOException {
        Runtime runtime = Runtime.getRuntime();
        runtime.exec(cmd);
    }
}
