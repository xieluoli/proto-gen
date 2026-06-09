/**
 * PRD ↔ 原型 双向高亮联动
 *
 * 用法：
 *   1) 引入 shared.css（含 .is-highlight / li[data-target] / .is-bullet-active 样式）
 *   2) 在原型组件上加 data-comp="<key>"，在 PRD bullet (<li>) 上加 data-target="<key>"
 *   3) 多对一写法：data-target="key1,key2"（hover 该 bullet 高亮多个组件）
 *
 * Scope：每个 .proto-with-prd 是独立命名空间，跨 section 不传染。
 * 视觉键：outline + var(--primary) 描边（跟随当前主题）/ 外发光，与组件自身 :hover 的 background 完全分离。
 */
(function() {
  function init() {
    document.querySelectorAll('.proto-with-prd').forEach(function(scope) {
      function decorateCard(target, on) {
        var card = target.closest && target.closest('.channel-card');
        if (!card) return;
        card.classList[on ? 'add' : 'remove']('is-bullet-active');
      }

      /* 正向：bullet → component */
      scope.querySelectorAll('li[data-target]').forEach(function(bullet) {
        var keys = bullet.dataset.target.split(',').map(function(s) { return s.trim(); }).filter(Boolean);
        var targets = [];
        keys.forEach(function(k) {
          scope.querySelectorAll('[data-comp="' + k + '"]').forEach(function(el) { targets.push(el); });
        });
        if (!targets.length) return;
        bullet.addEventListener('mouseenter', function() {
          bullet.classList.add('is-highlight');
          targets.forEach(function(t) { t.classList.add('is-highlight'); decorateCard(t, true); });
        });
        bullet.addEventListener('mouseleave', function() {
          bullet.classList.remove('is-highlight');
          targets.forEach(function(t) { t.classList.remove('is-highlight'); decorateCard(t, false); });
        });
      });

      /* 反向：component → bullet（子组件 stopPropagation 避免被父组件遮盖） */
      scope.querySelectorAll('[data-comp]').forEach(function(comp) {
        var key = comp.dataset.comp;
        var matched = [];
        scope.querySelectorAll('li[data-target]').forEach(function(b) {
          if (b.dataset.target.split(',').map(function(s) { return s.trim(); }).indexOf(key) !== -1) matched.push(b);
        });
        if (!matched.length) return;
        comp.addEventListener('mouseenter', function(e) {
          e.stopPropagation();
          comp.classList.add('is-highlight');
          matched.forEach(function(b) { b.classList.add('is-highlight'); });
        });
        comp.addEventListener('mouseleave', function(e) {
          e.stopPropagation();
          comp.classList.remove('is-highlight');
          matched.forEach(function(b) { b.classList.remove('is-highlight'); });
        });
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
