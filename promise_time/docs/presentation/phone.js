// 아이폰 틀 + 앱 화면(아이콘 없음) 생성 함수. 값은 앱의 실제 문구를 그대로 썼다.
function frame(inner, s, time){
  return `<div class=ip style="--s:${s}"><div class=body>
   <i class="btn a"></i><i class="btn b"></i><i class="btn c"></i><i class="btn d"></i>
   <div class=scr><div class=isl></div><div class=time>${time||'9:41'}</div>${inner}<div class=home></div></div></div></div>`;
}
function appScreen(o){
  const seg = `<div class=seg><div class="${o.kind==='취침'?'on':''}">취침</div><div class="${o.kind==='출근'?'on':''}">출근</div></div>`;
  const val = v => v ? `<b>${v}</b>` : `<b class=no>선택 안 함</b>`;
  const rows = (o.rows||[]).map(r=>`<div class=row>${r}</div>`).join('');
  return `<div class=app><h2>약속 시각 기록</h2>
   <div class=guide>오늘 정한 시각과 실제로 한 시각을 선택해 주세요</div>${seg}
   <div class=two><div class=tc><small>오늘 정한 시각은?</small>${val(o.target)}</div>
   <div class=tc><small>실제로 한 시각은?</small>${val(o.actual)}</div></div>
   <div class=rec>기록</div>
   ${o.result?`<div class=res>${o.result}</div>`:''}
   <div class=lh>이번 실행 중 기록 목록 · ${(o.rows||[]).length}건</div><div class=ls>앱을 다시 실행하면 사라져요</div>
   ${rows||'<div class=empty>아직 기록이 없어요</div>'}</div>`;
}
function alarmScreen(){
  const r=(t,d)=>`<div class=ar><div class=t>${t}</div><div class=d>${d}</div></div>`;
  return `<div class=al><h2>알람</h2>${r('16:25','주말 알바 · 토, 일')}${r('12:00','월')}${r('08:23','화, 금')}${r('08:25','화, 금')}${r('09:23','목')}</div>`;
}
