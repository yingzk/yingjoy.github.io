<br /><div style="display:inline-block">
{% if theme.footer.beian2.enable %}{#
#}  {{ next_url('http://www.miitbeian.gov.cn', theme.footer.beian2.icp ) }}
{% endif %}
</div>

<div style="display:inline-block">
{% if theme.footer.beian2.enable %}{#
#} <img src="{{ theme.footer.beian2.gongan_icon_url }}" align="center" height="18" width="18" style="display:inline-block;"/>
{{ next_url('http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=' + theme.footer.beian2.gongan_id,
  theme.footer.beian2.gongan_num + ' ') }}{#
#}{% endif %}
</div>
