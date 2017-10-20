package com.paasta.scwui.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Array;
import java.util.*;

/**
 * 
 * @author ijlee
 * 
 *         create by 2017.06.21
 *
 */
public class Common {
	private static Logger logger = LoggerFactory.getLogger(Common.class);
	/**
	 * 요청 파라미터들의 빈값 또는 null값 확인을 하나의 메소드로 처리할 수 있도록 생성한 메소드 요청 파라미터 중 빈값 또는
	 * null값인 파라미터가 있는 경우, false를 리턴한다.
	 *
	 * @param params
	 * @return
	 */
	public boolean stringNullCheck(String... params) {
		return Arrays.stream(params).allMatch(param -> null != param && !param.equals(""));
	}

	/**
	 * Object type 변수가 비어있는지 체크
	 * 
	 * @param obj
	 * @return Boolean : true / false
	 *  Create by injeong
	 */
	public static Boolean empty(Object obj) {

		if (obj instanceof String) {
			return obj == null || "".equals(obj.toString().trim());
		}
		if (obj instanceof List) {
			return obj == null || ((List) obj).isEmpty();
		}
		if (obj instanceof Map) {
			return obj == null || ((Map) obj).isEmpty();
		}
		if (obj instanceof Object[]) {
			return obj == null || Array.getLength(obj) == 0;
		}
		if (obj instanceof HttpSession) {
			return obj == null || ((HttpSession) obj).getAttributeNames().hasMoreElements();
		}
		if (obj instanceof LinkedHashMap) {
			return obj == null || ((LinkedHashMap) obj).isEmpty();
		}
		if (obj instanceof Map) {
			return obj == null || ((Map) obj).isEmpty();
		}
		return obj == null;
	}

	/**
	 * Object type 변수가 비어있지 않은지 체크
	 * 
	 * @param obj
	 * @return Boolean : true / false
	 */
	public static Boolean notEmpty(Object obj) {
		return !empty(obj);
	}

	/**
	 *  Object type 변수가 비어있는지 확인하여 비어있으면 rtn값을 주고 비어있지 않으면 Object 를 보내준다.
	 *  @param obj 확인할 변수
	 *  @param rtn 비어있으면 보내줄값
	 *  Create by injeong
	 */

	public static Object NotNullrtnByobj(Object obj, Object rtn) {
        if (empty(obj)) {
			return rtn;
		}
        return obj;
	}

	/**
	 * map 이 비어있는지 확인한후 get 호출을 하기위한 requestParam형태로 바꾼다.
	 * @param map
	 * @return requestUrl String
	 */

	public static String requestParamByMap(Map map){
		logger.debug("logger: method:requestParamByMap: " );
		StringBuilder requestUrl = new StringBuilder();

		if(!empty(map)){
			List<String> lstKey = new ArrayList(map .keySet());
			List<Object[]> lstValue = new ArrayList(map .values());
			for(int i = 0 ; i < lstKey.size(); i++){
				if(i !=0) {
					requestUrl.append("&");
				}
				logger.debug("map:key::"+lstKey.get(i) + ":: value: " + Arrays.toString(lstValue.get(i)));
				requestUrl.append(lstKey.get(i)).append("=").append(lstValue.get(i));
			}
		}
		logger.debug("logger: requestUrl:: " +requestUrl);
		return requestUrl.toString();

	}
	public static Map convertMapByRequest(HttpServletRequest request){

		Map requestParameterMap = request.getParameterMap();
		Map map = new HashMap();
		if(!Common.empty(requestParameterMap)){
			List<String> lstKey = new ArrayList(requestParameterMap .keySet());
			List<Object[]> lstValue = new ArrayList(requestParameterMap .values());
			for(int i = 0 ; i < lstKey.size(); i++){
				map.put(lstKey.get(i), lstValue.get(i)[0]);
			}

		}
	return map;
	}
	public static Map convertMapByRequest(HttpServletRequest request, Map rtnMap){
		Map map = convertMapByRequest(request);
		rtnMap.putAll(map);
		return rtnMap;
	}
	public static Map convertMapByLinkedHashMap(LinkedHashMap linkedHashMap){
		Map map = new HashMap();
		if(!Common.empty(linkedHashMap)){
			List<String> lstKey = new ArrayList(linkedHashMap .keySet());
			List<Object[]> lstValue = new ArrayList(linkedHashMap .values());
			for(int i = 0 ; i < lstKey.size(); i++){
				map.put(lstKey.get(i), lstValue.get(i));
			}

		}
		return map;
	}
}
