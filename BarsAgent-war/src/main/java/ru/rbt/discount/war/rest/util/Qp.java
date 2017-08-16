package ru.rbt.discount.war.rest.util;

/**
 * Created by KryukovMV on 27.03.2017.
 */
public class Qp {

    public static String valid(String s) {
        return s != null && s.trim().isEmpty() ? null : s;
    }
}
