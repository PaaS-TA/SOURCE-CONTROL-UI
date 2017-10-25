<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="container">
    <!-- 이동경로 :s -->
    <div class="location">
        <ul>
            <li><a href="/user/repository/" class="home">홈으로</a></li>
            <li><a href="#" title="">레파지토리 신규생성</a></li><!--마지막 경로일때-->
        </ul>
    </div>
    <!--//이동경로 :e -->

    <!-- contents :s -->
    <div class="contents">
        <!-- Form 테이블 :s -->
        <table summary="사용자생성 입력 테이블입니다." class="tbl_form02">
            <caption> 사용자생성</caption>
            <colgroup>
                <col style="width: 18%"/>
                <col style="width: *"/>
            </colgroup>

            <tbody>
            <tr>
                <th>레파지토리 명 (<span class="essential">*필수</span>)</th>
                <td><input type="text" id="RepositoryName" name="RepositoryName" value="" placeholder=""><span class="essential"> *영문만 허용</span>
                    <p class="desc" style="color:#fb5666;display: none" id="createRepositoryNameAlert">* 레파지토리명 형식이 올바르지 않습니다.</p></td>
            </tr>

            <tr>
                <th>유형 (<span class="essential">*필수</span>)</th>
                <td>
                    <select id="type" name="type" class="type" title="유형을 선택합니다." style="width:51%;">
                        <option value="git">Git</option>
                        <option value="svn">SVN</option>
                        </optgroup>
                    </select>
                </td>
            </tr>

            <tr style="display: none;">
                <th>공개여부 (<span class="essential">*필수</span>)</th>
                <td>
                    <label><input type="radio" name="public" id="public3" value=true>공개(Public)</label>
                    <label><input type="radio" name="public" id="public4" value=false  checked="checked">비공개(Private)</label>
                </td>
            </tr>

            <tr>
                <th>레파지토리 설명 (<span class="f12">선택</span>)</th>
                <td><textarea type="text" name="description" id="description"  colos="20" rows="5" style=""></textarea></td>
            </tr>
            </tbody>
        </table>
        <!--//Form 테이블 :e -->

        <!--버튼 영역 :s -->
        <div class="btn_Area plr20 fr">
            <jsp:include page="../common/buttonCreateOnclick.jsp"></jsp:include>
            <%--<button type="button" class="button btn_default" title="생성" id="btnCreate">생성</button>--%>
            <button type="button" class="button btn_default" title="취소" id="btnCancel">취소</button>
        </div>
        <!--버튼 영역-->
    </div>
    <!--//contents :e -->
</div>
<!--//contaniner :e -->
<form id="form1" method ='get' action ="/user/repository/"></form>

<script type="text/javascript">
    /* 레파지토리 생성
     *  public3[공개], private[비공개]4 => header.jsp 똑같은 옵션 public1[공개],private2[비공개]에서 충돌 우려 하여 숫자부여
     * */
    // CREATE REPOSITORY
    var createRepository = function () {
        var createRepositoryName = document.getElementById('RepositoryName').value;
        if(!validRepositoryName(createRepositoryName)){
            $("#createRepositoryNameAlert").show();
            $('#RepositoryName').focus();
            return;
        }
        var publicValue;
        publicValue = document.getElementById('public3').checked;

        var reqParam = {
            name: document.getElementById('RepositoryName').value,
            description: document.getElementById('description').value,
            type: document.getElementById('type').value,
            public: publicValue,
        };

        console.log("::::들어오니? 2탄::::" + JSON.stringify(reqParam));
        procCallAjax("post", "/user/createRepository.do", reqParam, callbackCreateRepository);
        console.log("::::들어오니? 3탄::::");
    };

    // CALLBACK
    var callbackCreateRepository = function (data) {
        if(null!=data.error){
            popupAlertClick(data.error);
            return;
        }
        procPopupAlert("레파지토리가 신규 생성 되었습니다.",'$("#form1").submit()', 'return');
    };

    // BIND
    $("#btnCancel").on("click", function () {
        procMovePage(-1);
    });

    // ON LOAD
    $(document.body).ready(function () {
        $("#RepositoryName").keyup(function () {
            var createRepositoryName = $("#RepositoryName").val();
            if(!validRepositoryName(createRepositoryName)){
                $("#createRepositoryNameAlert").show();
            }else{
                $("#createRepositoryNameAlert").hide();
            }
        });

        $("#buttonCreateOnclick").text("생성");
        $("#buttonCreateOnclick").click(function (event) {
            var validation_LanguageCheck = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
            if (document.getElementById('RepositoryName').value === null || validation_LanguageCheck.test(document.getElementById('RepositoryName').value)) {
                popupAlertClick("올바른 레파지토리 명 형식이 아닙니다.");
                document.getElementById('RepositoryName').value = "";
                return;
            }
            else{
                createRepository();
            }
        });
    });

</script>
<!--//select 스크립트-->