<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="container">
    <!-- 이동경로 :s -->
    <div class="location">
        <ul>
            <li><a href="/user/repository/" class="home">home</a></li>
            <li><a href="#" title="">Create a new repository</a></li><!--마지막 경로일때-->
        </ul>
    </div>
    <!-- contents :s -->
    <div class="contents">
        <!-- Form 테이블 :s -->
        <table summary="This is a user-created input table." class="tbl_form02">
            <caption> create user</caption>
            <colgroup>
                <col style="width: 18%"/>
                <col style="width: *"/>
            </colgroup>
            <tbody>
            <tr>
                <th>Respository name (<span class="essential">*required</span>)</th>
                <td><input type="text" id="RepositoryName" name="RepositoryName" value="" placeholder=""><span class="essential"> *English only</span>
                    <p class="desc" style="color:#fb5666;display: none" id="createRepositoryNameAlert">* The format of the repository name is incorrect.</p></td>
            </tr>
            <tr>
                <th>Type (<span class="essential">*required</span>)</th>
                <td>
                    <select id="type" name="type" class="type" title="Select a type." style="width:51%;">
                        <option value="git">Git</option>
                        <option value="svn">SVN</option>
                        </optgroup>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Repository desc (<span class="f12">optional</span>)</th>
                <td><textarea type="text" name="description" id="description"  colos="20" rows="5" style=""></textarea></td>
            </tr>
            </tbody>
        </table>
        <!--//Form 테이블 :e -->

        <!--버튼 영역 :s -->
        <div class="btn_Area plr20 fr">
            <jsp:include page="../common/buttonCreateOnclick.jsp"></jsp:include>
            <button type="button" class="button btn_default" title="cancellation" id="btnCancel">Cancel</button>
        </div>
        <!--버튼 영역-->
    </div>
    <!--//contents :e -->
</div>
<!--//contaniner :e -->
<form id="form1" method ='get' action ="/user/repository/"></form>

<script type="text/javascript">
    /* 레파지토리 생성*/
    // CREATE REPOSITORY
    var createRepository = function () {
        var createRepositoryName = document.getElementById('RepositoryName').value;
        if(!validRepositoryName(createRepositoryName)){
            $("#createRepositoryNameAlert").show();
            $('#RepositoryName').focus();
            return;
        }
        var publicValue = false; //항상 private 만생성함.
        var reqParam = {
            name: document.getElementById('RepositoryName').value,
            description: document.getElementById('description').value,
            type: document.getElementById('type').value,
            public: publicValue,
        };
        procCallAjax("post", "/user/createRepository.do", reqParam, callbackCreateRepository);
    };

    // CALLBACK
    var callbackCreateRepository = function (data) {
        if(null!=data.error){
            popupAlertClick(data.error);
            return;
        }
        procPopupAlert("A new repository has been created.",'$("#form1").submit()', 'return');
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

        $("#buttonCreateOnclick").text("Ok");
        $("#buttonCreateOnclick").click(function (event) {
            var validation_LanguageCheck = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
            if (document.getElementById('RepositoryName').value === null || validation_LanguageCheck.test(document.getElementById('RepositoryName').value)) {
                popupAlertClick("This is not a valid repository name format.");
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
