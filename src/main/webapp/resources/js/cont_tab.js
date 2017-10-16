// JavaScript Document
// 본문 탭메뉴(리본포함) 스크립트 
function main_tab(num){	
	var f = $('.main_tab').find('li');
	for ( var i = 0; i < f.length; i++ ) {			
		if ( i == num) {			
			f.eq(i).addClass('active');	
			$('.main_tab0' + i ).show();
		} else {
			f.eq(i).removeClass('active');					
			$('.main_tab0' + i ).hide();
		}
	}
}
function sub_tab(num){	
	var f = $('.sub_tab').find('li');
	for ( var i = 0; i < f.length; i++ ) {			
		if ( i == num) {			
			f.eq(i).addClass('active');	
			$('.sub_tab_cont0' + i ).show();
		} else {
			f.eq(i).removeClass('active');					
			$('.sub_tab_cont0' + i ).hide();
		}
	}
}