((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,C,A={
blS(d){var x=C.b.jo(d,0,A.bEM()),w=x+((x&67108863)<<3)&536870911
w^=w>>>11
return w+((w&16383)<<15)&536870911},
bcE(d,e){var x,w,v
if(d===e)return!0
x=J.be(d)
w=J.be(e)
if(x.gG(d)!==w.gG(e))return!1
for(v=0;v<x.gG(d);++v)if(!A.bcL(x.da(d,v),w.da(e,v)))return!1
return!0},
bGF(d,e){var x
if(d===e)return!0
if(d.gG(d)!==e.gG(e))return!1
for(x=d.gag(d);x.v();)if(!e.fu(0,new A.b82(x.gN())))return!1
return!0},
bG0(d,e){var x,w
if(d===e)return!0
if(d.gG(d)!==e.gG(e))return!1
for(x=d.gd7(),x=x.gag(x);x.v();){w=x.gN()
if(!A.bcL(d.h(0,w),e.h(0,w)))return!1}return!0},
bcL(d,e){var x
if(d==null?e==null:d===e)return!0
if(typeof d=="number"&&typeof e=="number")return!1
else{x=y.a
if(x.b(d)||y.A.b(d))x=x.b(e)||y.A.b(e)
else x=!1
if(x)return J.e(d,e)
else{x=y.g
if(x.b(d)&&x.b(e))return A.bGF(d,e)
else{x=y.F
if(x.b(d)&&x.b(e))return A.bcE(d,e)
else{x=y.B
if(x.b(d)&&x.b(e))return A.bG0(d,e)
else{x=d==null?null:J.a6(d)
if(x!=(e==null?null:J.a6(e)))return!1
else if(!J.e(d,e))return!1}}}}}return!0},
bbW(d,e){var x,w,v,u={}
u.a=d
u.b=e
if(y.B.b(e)){C.b.aA(A.bgj(e.gd7(),new A.b5a(),y.b),new A.b5b(u))
return u.a}x=y.g.b(e)?u.b=A.bgj(e,new A.b5c(),y.b):e
if(y.F.b(x)){for(x=J.bl(x);x.v();){w=x.gN()
v=u.a
u.a=(v^A.bbW(v,w))>>>0}return(u.a^J.cm(u.b))>>>0}d=u.a=d+J.S(x)&536870911
d=u.a=d+((d&524287)<<10)&536870911
return d^d>>>6},
bG1(d,e){return d.j(0)+"("+new B.a_(e,new A.b7K(),B.a3(e).i("a_<1,h>")).bL(0,", ")+")"},
b82:function b82(d){this.a=d},
b5a:function b5a(){},
b5b:function b5b(d){this.a=d},
b5c:function b5c(){},
b7K:function b7K(){},
bgj(d,e,f){var x=B.W(d,f)
C.b.fH(x,e)
return x},
bfw(){var x=$.bfv
return x==null?$.bfv=!1:x}}
J=c[1]
B=c[0]
C=c[2]
A=a.updateHolder(c[51],A)
var z=a.updateTypes(["k(k,m?)"])
A.b82.prototype={
$1(d){return A.bcL(this.a,d)},
$S:35}
A.b5a.prototype={
$2(d,e){return J.S(d)-J.S(e)},
$S:262}
A.b5b.prototype={
$1(d){var x=this.a,w=x.a,v=x.b
v.toString
x.a=(w^A.bbW(w,[d,y.B.a(v).h(0,d)]))>>>0},
$S:19}
A.b5c.prototype={
$2(d,e){return J.S(d)-J.S(e)},
$S:262}
A.b7K.prototype={
$1(d){return J.dd(d)},
$S:159};(function installTearOffs(){var x=a._static_2
x(A,"bEM","bbW",0)})();(function inheritance(){var x=a.inheritMany
x(B.cR,[A.b82,A.b5b,A.b7K])
x(B.es,[A.b5a,A.b5c])})()
var y={a:B.v("mJ"),A:B.v("aG"),F:B.v("L<@>"),B:B.v("bc<@,@>"),g:B.v("bD<@>"),b:B.v("@")};(function staticFields(){$.bfv=null})()};
(a=>{a["RNeg5AudoRxMM+gs8D2de4alQV4="]=a.current})($__dart_deferred_initializers__);