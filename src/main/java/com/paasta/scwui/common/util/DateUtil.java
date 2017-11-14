package com.paasta.scwui.common.util;

import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by lena on 2017-06-15.
 */
@Component
public class DateUtil {

    public static String convertLongToTime(long time) {
        Date date = new Date(time);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);

        return sdf.format(date);
    }

    private static String rtnFormatString(String strFormat, Date date) {

        SimpleDateFormat sdf = new SimpleDateFormat(strFormat, Locale.KOREA);
        String rtnStr = sdf.format(date);

        return rtnStr;

    }
    /**
     * number 형태의 String을 가져와서 날짜 포맷으로 return 해준다.
     * @param strInt
     * @param strFormat
     * @return
     */
    public static String parseStringDatebyInt(String strFormat, String strInt){

        String rtnDate = "";
        if(Common.notEmpty(strInt)) {
            long currentTime = Long.parseLong(strInt);
            rtnDate = DateUtil.rtnFormatString(strFormat, new Date(currentTime));
        }
        return rtnDate;
    }
}
