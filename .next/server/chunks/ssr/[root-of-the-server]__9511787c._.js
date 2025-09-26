module.exports = [
"[externals]/@react-three/fiber [external] (@react-three/fiber, cjs)", ((__turbopack_context__, module, exports) => {

const mod = __turbopack_context__.x("@react-three/fiber", () => require("@react-three/fiber"));

module.exports = mod;
}),
"[externals]/@react-three/drei [external] (@react-three/drei, cjs)", ((__turbopack_context__, module, exports) => {

const mod = __turbopack_context__.x("@react-three/drei", () => require("@react-three/drei"));

module.exports = mod;
}),
"[externals]/three [external] (three, esm_import)", ((__turbopack_context__) => {
"use strict";

return __turbopack_context__.a(async (__turbopack_handle_async_dependencies__, __turbopack_async_result__) => { try {

const mod = await __turbopack_context__.y("three");

__turbopack_context__.n(mod);
__turbopack_async_result__();
} catch(e) { __turbopack_async_result__(e); } }, true);}),
"[externals]/three/examples/jsm/geometries/RoundedBoxGeometry.js [external] (three/examples/jsm/geometries/RoundedBoxGeometry.js, esm_import)", ((__turbopack_context__) => {
"use strict";

return __turbopack_context__.a(async (__turbopack_handle_async_dependencies__, __turbopack_async_result__) => { try {

const mod = await __turbopack_context__.y("three/examples/jsm/geometries/RoundedBoxGeometry.js");

__turbopack_context__.n(mod);
__turbopack_async_result__();
} catch(e) { __turbopack_async_result__(e); } }, true);}),
"[project]/src/pages/index.js [ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

return __turbopack_context__.a(async (__turbopack_handle_async_dependencies__, __turbopack_async_result__) => { try {

__turbopack_context__.s([
    "default",
    ()=>Home
]);
var __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__ = __turbopack_context__.i("[externals]/react/jsx-dev-runtime [external] (react/jsx-dev-runtime, cjs)");
var __TURBOPACK__imported__module__$5b$externals$5d2f40$react$2d$three$2f$fiber__$5b$external$5d$__$2840$react$2d$three$2f$fiber$2c$__cjs$29$__ = __turbopack_context__.i("[externals]/@react-three/fiber [external] (@react-three/fiber, cjs)");
var __TURBOPACK__imported__module__$5b$externals$5d2f40$react$2d$three$2f$drei__$5b$external$5d$__$2840$react$2d$three$2f$drei$2c$__cjs$29$__ = __turbopack_context__.i("[externals]/@react-three/drei [external] (@react-three/drei, cjs)");
var __TURBOPACK__imported__module__$5b$externals$5d2f$three__$5b$external$5d$__$28$three$2c$__esm_import$29$__ = __turbopack_context__.i("[externals]/three [external] (three, esm_import)");
var __TURBOPACK__imported__module__$5b$externals$5d2f$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js__$5b$external$5d$__$28$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js$2c$__esm_import$29$__ = __turbopack_context__.i("[externals]/three/examples/jsm/geometries/RoundedBoxGeometry.js [external] (three/examples/jsm/geometries/RoundedBoxGeometry.js, esm_import)");
var __turbopack_async_dependencies__ = __turbopack_handle_async_dependencies__([
    __TURBOPACK__imported__module__$5b$externals$5d2f$three__$5b$external$5d$__$28$three$2c$__esm_import$29$__,
    __TURBOPACK__imported__module__$5b$externals$5d2f$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js__$5b$external$5d$__$28$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js$2c$__esm_import$29$__
]);
[__TURBOPACK__imported__module__$5b$externals$5d2f$three__$5b$external$5d$__$28$three$2c$__esm_import$29$__, __TURBOPACK__imported__module__$5b$externals$5d2f$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js__$5b$external$5d$__$28$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js$2c$__esm_import$29$__] = __turbopack_async_dependencies__.then ? (await __turbopack_async_dependencies__)() : __turbopack_async_dependencies__;
;
;
;
;
;
const Cube = ()=>{
    const geometry = new __TURBOPACK__imported__module__$5b$externals$5d2f$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js__$5b$external$5d$__$28$three$2f$examples$2f$jsm$2f$geometries$2f$RoundedBoxGeometry$2e$js$2c$__esm_import$29$__["RoundedBoxGeometry"](1, 1, 1, 10, 0.1);
    const material = new __TURBOPACK__imported__module__$5b$externals$5d2f$three__$5b$external$5d$__$28$three$2c$__esm_import$29$__["MeshStandardMaterial"]({
        color: 0x2a2a2a
    });
    const size = 1.1;
    const cubes = [];
    for(let x = -1; x <= 1; x++){
        for(let y = -1; y <= 1; y++){
            for(let z = -1; z <= 1; z++){
                if (x === 0 && y === 0 && z === 0) continue;
                cubes.push(/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])("mesh", {
                    position: [
                        x * size,
                        y * size,
                        z * size
                    ],
                    geometry: geometry,
                    material: material
                }, `${x}-${y}-${z}`, false, {
                    fileName: "[project]/src/pages/index.js",
                    lineNumber: 15,
                    columnNumber: 20
                }, ("TURBOPACK compile-time value", void 0)));
            }
        }
    }
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])("group", {
        children: cubes
    }, void 0, false, {
        fileName: "[project]/src/pages/index.js",
        lineNumber: 19,
        columnNumber: 10
    }, ("TURBOPACK compile-time value", void 0));
};
function Home() {
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])("div", {
        style: {
            width: '100vw',
            height: '100vh'
        },
        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$externals$5d2f40$react$2d$three$2f$fiber__$5b$external$5d$__$2840$react$2d$three$2f$fiber$2c$__cjs$29$__["Canvas"], {
            camera: {
                position: [
                    5,
                    5,
                    5
                ],
                fov: 50
            },
            children: [
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])("ambientLight", {
                    intensity: 1.5
                }, void 0, false, {
                    fileName: "[project]/src/pages/index.js",
                    lineNumber: 26,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])("pointLight", {
                    position: [
                        10,
                        10,
                        10
                    ],
                    intensity: 0.2
                }, void 0, false, {
                    fileName: "[project]/src/pages/index.js",
                    lineNumber: 27,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])(Cube, {}, void 0, false, {
                    fileName: "[project]/src/pages/index.js",
                    lineNumber: 28,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$externals$5d2f$react$2f$jsx$2d$dev$2d$runtime__$5b$external$5d$__$28$react$2f$jsx$2d$dev$2d$runtime$2c$__cjs$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$externals$5d2f40$react$2d$three$2f$drei__$5b$external$5d$__$2840$react$2d$three$2f$drei$2c$__cjs$29$__["OrbitControls"], {}, void 0, false, {
                    fileName: "[project]/src/pages/index.js",
                    lineNumber: 29,
                    columnNumber: 9
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/src/pages/index.js",
            lineNumber: 25,
            columnNumber: 7
        }, this)
    }, void 0, false, {
        fileName: "[project]/src/pages/index.js",
        lineNumber: 24,
        columnNumber: 5
    }, this);
}
__turbopack_async_result__();
} catch(e) { __turbopack_async_result__(e); } }, false);}),
"[externals]/next/dist/shared/lib/no-fallback-error.external.js [external] (next/dist/shared/lib/no-fallback-error.external.js, cjs)", ((__turbopack_context__, module, exports) => {

const mod = __turbopack_context__.x("next/dist/shared/lib/no-fallback-error.external.js", () => require("next/dist/shared/lib/no-fallback-error.external.js"));

module.exports = mod;
}),
];

//# sourceMappingURL=%5Broot-of-the-server%5D__9511787c._.js.map