<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Modal popup :s -->
<div class="modal-fade" id ="modalConfirm" role="dialog"  style="display: none;">
    <div class="modal-dialog" role="dialog">
        <div class="modal-content" id="modal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"  aria-label="Close"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <span class="modal-title" id="commonPopupConfirmTitle">알림</span>
            </div>
            <div class="modal-body">
                <p id="commonPopupConfirmMessage"></p>
            </div>
            <div class="modal-footer">
                <div class="fr">
                    <button type="button" class="button btn_pop" id="commonPopupConfirmButtonText" data-dismiss="modal">확인</button>
                    <button type="button" class="button btn_pop" data-dismiss="modal">취소 </button>
                </div>
            </div>
        </div>
    </div>
</div>

<%--POPUP ALERT :: BEGIN--%>
<div class="modal fade" id="modalAlert" role="dialog"  style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"> &times; </span></button>
                <h1 class="modal-title"> 알림 </h1>
            </div>
            <div class="modal-body">
                <p id="commonPopupAlertMessage"> MESSAGE </p>
            </div>
            <div class="modal-footer">
                <div class="fr">
                    <button type="button" class="button btn_pop fr" data-dismiss="modal"> 확인 </button>
                </div>
            </div>
        </div>
    </div>
</div>
<%--POPUP ALERT :: END--%>

<%--SPINNER :: BEGIN--%>
<div class="modal fade" id="modalSpinner" role="dialog" aria-labelledby="myModalLabel" data-keyboard="false" data-backdrop="static"  style="display: none;">
    <div class="container">
        <div class="row" style="">
            <div class="loader"></div>
        </div>
    </div>
</div>
<%--SPINNER :: END--%>
<script>
    $(document).ready(function () {

    });


</script>
