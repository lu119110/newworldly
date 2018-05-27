<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<html>
	<head>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />

		<title></title>
		<link type="text/css" rel="stylesheet"
			href="${pageContext.request.contextPath}/css/dhtmlgoodies_calendar.css?random=20051112"
			media="screen"></link>
		<script type="text/javascript"
			src="${pageContext.request.contextPath}/js/dhtmlgoodies_calendar.js?random=20060118"></script>
		<link href="${pageContext.request.contextPath}/css/mine.css"
			type="text/css" rel="stylesheet" />
		<script language="JavaScript"
			src="${pageContext.request.contextPath}/js/jquery-1.11.3.min.js"></script>
		<script>
		
        function freshPos(id,linindex,tablearea){
        //alert(linindex);
        var param="txdate="+$("#startDate").val()+"&tillid="+id;
        //alert(param);
        	$.post("${pageContext.request.contextPath}/clearPOSByTillid_sm.do",param,function(ret){
				//alert(ret);
				if(ret=="error"){
					alert("查询出错啦");
					return ;
				}
				var splitStr=ret.split("|");
				//alert(splitStr[0]);
				$("#"+tablearea+" tr:eq("+linindex+") td:eq(0)").text(splitStr[0]);
				$("#"+tablearea+" tr:eq("+linindex+") td:eq(1)").text(splitStr[1]);
				var clearFlag="";
				if(splitStr[2]=="1"){
				clearFlag="已清机";
				}
				$("#"+tablearea+" tr:eq("+linindex+") td:eq(2)").text(clearFlag);
				totalAomunt();	
				
			});
			//alert(id);
        	//var s=$("#table1 tr:eq("+linindex+") td:eq(1)").text();
        	//alert(s);
        	//$(".table_a tr:gt(0):eq(1) td:eq(1)").remove();
        	//alert($("#table1 tr:gt(0):eq(1)").remove());
        }
        function totalAomunt(){
							//加总金额
				var totalAm=new Number;
				totalAm=0;
				var lineAmount;
				for(tai=1;tai<5;tai++){
					$("#table"+tai+" tr").each(function(i){
						 if(i>0){
						  lineAmount=$("#table"+tai+" tr:eq("+i+") td:eq(1)").text();
						  if(lineAmount!=null && lineAmount!=""){
						  	totalAm=totalAm+Number(lineAmount);
						  }
	  					  //alert("这是第"+i+"行内容:"+lineAmount+"    |"+totalAm);
	  					 }
	    			});
				}
				$("#totalamount").text(totalAm.toFixed(2));
			        
        }
		$(function(){
			$(".clsync a").click(function(){
			
				var param="txdate="+$("#startDate").val();		
				var checkId="";
				$('input[name="chkFlag"]:checked').each(function(){ 
					checkId=checkId+","+$(this).val()
				}); 
				//alert(checkId);
				//param=param+"&chk="+checkId;
				$.post("${pageContext.request.contextPath}/clearPosAll_sm.do",param,function(ret){
					//alert(ret);
					$("#posRetDiv").empty();
					$("#posRetDiv").append(ret);
					var checkedidsarry=checkId.split(",");
					//alert(checkId);
					for(var i=1;i<checkedidsarry.length;i++){
						//alert(checkedidsarry[i]);
						$('#'+checkedidsarry[i]).attr("checked","checked");
						$("#trtillid" + checkedidsarry[i].split("_")[2]).addClass("check_trcss");
					}
					totalAomunt();
				});
			//
			});
		});
        $(function(){
        $("#dqsj").text(new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay()));
        	var d = new Date();
    		currentMonth = d.getMonth();
    		currentMonth++;
    		currentYear = d.getFullYear();
    		inputDay = d.getDate()/1;
    		//alert(currentYear+"-"+currentMonth+"-"+d.getDate());
    		//alert($("#startDate").val());
    		$("#startDate").val(currentYear+"-"+currentMonth+"-"+d.getDate());
    		$.post("${pageContext.request.contextPath}/clearPosAll_sm.do","txdate="+$("#startDate").val(),function(ret){
					//alert(ret);
					$("#posRetDiv").empty().html(ret);
					//$("#posRetDiv").append(ret);
			//加总金额
			totalAomunt();			//
			});
        });	//$.get("${pageContext.request.contextPath}/sycnDSBasicData.do",);
      var timedjs;
        var djsInteval=10;
		function clickAutoFresh(flag){
			//alert(flag);
			if(flag){
			$("#djs").empty().text(djsInteval);
			timedjs= setInterval("djsFresh();",1000);
			}else{
				clearTimeout(timedjs);
			}
		}
		function djsFresh(){
			var i=Number($("#djs").text());
			i=i-1;
			$("#djs").empty().text(i);
			if(i<=0){
				$(".clsync a").click();
				//alert("ok");
				$("#djs").empty().text(djsInteval);
			}else{
				$("#djs").empty().text(i);
			}
			
		}
		setInterval("dqsj.innerHTML=new Date().toLocaleString()+' 星期'+'日一二三四五六'.charAt(new Date().getDay());",1000);
        </script>
	</head>
	<body>
		<style>
.tr_color {
	background-color: #9F88FF
}
</style>
		<div class="div_head">
			<span> <span style="float: left;">超市>POS机状态</span> </span>
		</div>
		<div></div>
		<div class="div_search">
			<span> <!-- form action="#" method="get">
                   		 品牌<select name="s_product_mark" style="width: 100px;">
                        <option selected="selected" value="0">请选择
                        </option>
                        <option value="1">苹果apple</option>
                    </select>
                    <input value="查询" type="submit" />
                </form-->
				<form>
					<span style="float: left; margin-right: 8px; font-weight: bold;">日期：<input
							class="inputC" type="text" value="" readonly name="startDate"
							id="startDate"> <input type="button" value="..."
							onclick="displayCalendar(document.forms[0].startDate, 'yyyy-mm-dd', this);">
					</span>
				</form> <span class="clsync"
				style="float: left; margin-right: 8px; font-weight: bold;"> <a
					style="text-decoration: none;" href="javascript:void(0)">刷新</a> </span> </span>
			<span style="float: left; margin-right: 8px; font-weight: bold;">
				合计金额： <span id="totalamount"> 0</span> </span>
			</span>
						<span  style="float: left; margin-right: 8px; font-weight: bold;">
			| 当前时间：<span id="dqsj">  
			</span>
			</span>
			<span  style="float: left; margin-right: 8px; font-weight: bold;">
			| 自动刷新 <input type="checkBox" id="autoFresh" onclick="clickAutoFresh(this.checked)"><span id="djs">  
			</span>
			</span>	
		</div>
		<div style="font-size: 13px; margin: 10px 5px;" id="posRetDiv">

		</div>
	</body>
</html>