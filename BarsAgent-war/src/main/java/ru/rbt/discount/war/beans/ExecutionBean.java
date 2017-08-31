package ru.rbt.discount.war.beans;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

/**
 * Created by er22317 on 16.08.2017.
 */
public class ExecutionBean {
    public void exec(String cmd) throws IOException {
        Runtime runtime = Runtime.getRuntime();
        Process process = runtime.exec(cmd);
    }
    public void proc(String cmd) throws IOException {
        Process process = new ProcessBuilder()
                .redirectOutput(ProcessBuilder.Redirect.INHERIT)
                .redirectError(ProcessBuilder.Redirect.INHERIT)
                .command(cmd)
                .start();
    }
    public void javaProc(String cmd) throws IOException {
        String run = "java.exe -cp \"c:/ecpr/BARS_LOADER/BANK/target/bank.jar;c:/ecpr/BARS_LOADER/BANK/target/bank-0.0.28-SNAPSHOT-loader/*;c:/ecpr/BARS_LOADER/BANK/janis/*;c:/ecpr/BARS_LOADER/BANK/*\" -Dlog4j.configuration=c:/ecpr/BARS_LOADER/BANK/logger.properties";
        String[] runParams = run.split(" ");
//        String[] runParams = new String[]{"java.exe",
//                "-cp",
//                "c:/ecpr/BARS_LOADER/BANK/target/bank.jar;c:/ecpr/BARS_LOADER/BANK/target/bank-0.0.28-SNAPSHOT-loader/*;c:/ecpr/BARS_LOADER/BANK/*",
//                "-Dlog4j.configuration=logger.properties"};
        String[] classPar = cmd.split("_");
        String[] both = Stream.concat(Arrays.stream(runParams), Arrays.stream(classPar)).toArray(String[]::new);
        Process process = new ProcessBuilder()
                .redirectOutput(ProcessBuilder.Redirect.INHERIT)
                .redirectError(ProcessBuilder.Redirect.INHERIT)
                .directory(new File("c:/ecpr/BARS_LOADER/BANK"))
                .command(Arrays.asList(both))
                .start();
    }
}
