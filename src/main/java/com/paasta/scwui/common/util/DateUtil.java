package com.paasta.scwui.common.util;

import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by lena on 2017-06-15.
 */
@Component
public class DateUtil {

    public static String currentDateTime() {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREA);
        String currentDateTime = sdf.format(new Date());

        return currentDateTime;

    }


    public static String convertLongToTime(long time) {
        Date date = new Date(time);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        return sdf.format(date);
    }

    public static String convertStringFormat(String sDateTime, String sFormat) {

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        SimpleDateFormat convertFormatter = new SimpleDateFormat(sFormat);

        try {
            if(Common.empty(sDateTime)){
                return sDateTime;
            }
            Date date = formatter.parse(sDateTime);

            System.out.println(date);

            return convertFormatter.format(date);

        } catch (ParseException e) {
            e.printStackTrace();
            return sDateTime;
        }
    }


    public static String rtnFormatString(String strFormat, Date date) {

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
