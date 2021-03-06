<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>操作日志管理</title>

<script type="text/javascript">
	/*
	*删除日志
	*/
	function deleteRecord(id){
		var ids = [];  
        var rows = $('#userInfo').datagrid('getSelections');  
        for(var i=0; i<rows.length; i++){  
            var row = rows[i];  
            ids.push(row.id);  
        }
	    if(ids == ""){
	    	$.messager.alert("用户提示", "<br>至少选择1条记录删除", "info");
	    	return;
	    }
		$.messager.confirm('用户确认', '<br>确定删除该'+rows.length+'条记录？', function(r){
			if(r){
				$.ajax({
					type : 'post',
					url : '${ctx }/security/management/operatinglog/delete.action?id='+ids,
					dataType : 'json',
					async : false,
					success : function(data){
						if(data){
							$.messager.alert("用户提示", "<br>删除成功，影响行数"+rows.length, "info", function(){
								window.location.reload();
							});
						}else{
							$.messager.alert("用户提示", "<br>删除失败", "info");
						}
					}
				});
			}else{
				return;
			}
		});
	}
////////////////////////////////////////////////////页面分页控件////////////////////////////////////////////////////////////////
	$(function(){
			var pager = $('#userInfo').datagrid('getPager');	// get the pager of datagrid
			pager.pagination({
				total:parseInt('${page.totalCount }'),
				pageList: [10,15,20],
				pageNumber:parseInt('${page.pageNo }'),
				pageSize:parseInt('${page.pageSize }'),
				onSelectPage : function(pageNumber, pageSize){
					window.location.href="${ctx }/security/management/operatinglog/log.action?pageNo="+pageNumber+"&pageSize="+pageSize;
				}
			});
	});
</script>
</head>
<body>
	<div id="toolbar" style="display: none">
		<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="javascript:deleteRecord()">删除所选</a>
	</div>
	<table id="userInfo" class="easyui-datagrid" data-options="fit:true,fitColumns:true,loadMsg:'加载用户操作日志信息...',
	pagination:true, title:'日志列表', rownumbers:true, toolbar:'#toolbar', iconCls:'icon-save',scrollbarSize:0" style="display: none">  
	    <thead>  
	        <tr>
	        	<th data-options="field:'id',checkbox:true"></th>
	        	<th data-options="field:'loginName'">操作登录名</th>
				<th data-options="field:'nickname'" >操作员名字</th>
				<th data-options="field:'happenTime'" >操作时间</th>
				<th data-options="field:'module'" >操作模块</th>
				<th data-options="field:'comments'" >操作模块</th>
	        </tr>  
	    </thead>  
	    <tbody>
	    	<c:forEach items="${logList }" var="log">
	        <tr>
	        	<td>${log.id }</td>
	        	<td>${log.loginName }</td>
				<td>${log.nickname }</td>
				<td><fmt:formatDate value='${log.happenTime }' pattern='yyyy-MM-dd HH:mm:ss'/></td>
				<td>${log.module }</td>
				<td>${log.comments }</td>
	        </tr>
	        </c:forEach>
	    </tbody>  
	</table>
</body>
</html>