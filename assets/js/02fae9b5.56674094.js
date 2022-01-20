"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[331],{3905:function(e,t,r){r.d(t,{Zo:function(){return c},kt:function(){return f}});var n=r(67294);function o(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function l(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){o(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function u(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var i=n.createContext({}),p=function(e){var t=n.useContext(i),r=t;return e&&(r="function"==typeof e?e(t):l(l({},t),e)),r},c=function(e){var t=p(e.components);return n.createElement(i.Provider,{value:t},e.children)},s={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},d=n.forwardRef((function(e,t){var r=e.components,o=e.mdxType,a=e.originalType,i=e.parentName,c=u(e,["components","mdxType","originalType","parentName"]),d=p(r),f=o,h=d["".concat(i,".").concat(f)]||d[f]||s[f]||a;return r?n.createElement(h,l(l({ref:t},c),{},{components:r})):n.createElement(h,l({ref:t},c))}));function f(e,t){var r=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=r.length,l=new Array(a);l[0]=d;var u={};for(var i in t)hasOwnProperty.call(t,i)&&(u[i]=t[i]);u.originalType=e,u.mdxType="string"==typeof e?e:o,l[1]=u;for(var p=2;p<a;p++)l[p]=r[p];return n.createElement.apply(null,l)}return n.createElement.apply(null,r)}d.displayName="MDXCreateElement"},76647:function(e,t,r){r.r(t),r.d(t,{frontMatter:function(){return u},contentTitle:function(){return i},metadata:function(){return p},toc:function(){return c},default:function(){return d}});var n=r(87462),o=r(63366),a=(r(67294),r(3905)),l=["components"],u={},i="uStud",p={type:"mdx",permalink:"/uStud/",source:"@site/pages/index.md"},c=[{value:"Purpose",id:"purpose",children:[],level:2},{value:"What is planned?",id:"what-is-planned",children:[],level:2},{value:"How to help?",id:"how-to-help",children:[],level:2},{value:"To generate the project",id:"to-generate-the-project",children:[],level:2}],s={toc:c};function d(e){var t=e.components,r=(0,o.Z)(e,l);return(0,a.kt)("wrapper",(0,n.Z)({},s,r,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"ustud"},"uStud"),(0,a.kt)("h2",{id:"purpose"},"Purpose"),(0,a.kt)("p",null,"This tool is made for the creation of stud maps. It has several uilities avaliable to help. For the time being, they are:"),(0,a.kt)("ol",null,(0,a.kt)("li",{parentName:"ol"},"Studder: Studs."),(0,a.kt)("li",{parentName:"ol"},"Painter: Paints studs.")),(0,a.kt)("h2",{id:"what-is-planned"},"What is planned?"),(0,a.kt)("p",null,"Go ahead and look in projects for the time being for what's planned next for the tool."),(0,a.kt)("h2",{id:"how-to-help"},"How to help?"),(0,a.kt)("p",null,"Create an issue for the feature or problem you may have with the tool. Features should be discussed beforehand. However, bugfixes can have their PRs immediately made."),(0,a.kt)("h2",{id:"to-generate-the-project"},"To generate the project"),(0,a.kt)("p",null,"This tool uses Rojo."),(0,a.kt)("p",null,"To build the place from scratch, use:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-bash"},'rojo build -o "uStud.rbxlx"\n')),(0,a.kt)("p",null,"Next, open ",(0,a.kt)("inlineCode",{parentName:"p"},"uStud.rbxlx")," in Roblox Studio and start the Rojo server:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-bash"},"rojo serve\n")),(0,a.kt)("p",null,"For more help, check out ",(0,a.kt)("a",{parentName:"p",href:"https://rojo.space/docs"},"the Rojo documentation"),"."))}d.isMDXComponent=!0}}]);