Shader "Custom/Cg Basic PBR" 
{
		// This shader has triplanar blending, so it doesn't use any UV channel
        Properties 
        {
                _Color ("Color", Color) = (1,1,1,1)
                _MainTex ("Albedo (RGB)", 2D) = "white" {}
                _Glossiness ("Smoothness", Range(0,1)) = 0.5
                _Metallic ("Metallic", Range(0,1)) = 0.0
                _Bump ("Bump", 2D) = "bump"
        }

        SubShader 
        {
                Tags { "RenderType"="Opaque" }
                LOD 200
                
                CGPROGRAM
                // Physically based Standard lighting model, and enable shadows on all light types
                #pragma surface surf Standard fullforwardshadows
                #pragma vertex vert

                #pragma target 5.0

                sampler2D _MainTex;
                sampler2D _Bump;

                struct Input 
                {
                        float2 uv_MainTex;
                        half3 vertex;
                        half3 blending;
                };

                half _Glossiness;
                half _Metallic;
                fixed4 _Color;

                // To use hardware accelerated instancing
                UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
                UNITY_INSTANCING_BUFFER_END(Props)

                void vert(inout appdata_full v, out Input o)
                {
                        UNITY_INITIALIZE_OUTPUT(Input, o);

                        //v.vertex.xyz += v.normal * sin(_Time.w + v.vertex.x * 20.0) * 0.05;

                        o.blending = abs(v.normal);

                        o.vertex = v.vertex.xyz;
                }

                half3 GetNormalMapTriplanar(sampler2D texSampler, half3 vertex, half3 blending, half scale)
                {
                        half3 xAxis = UnpackNormal(tex2D(texSampler, (vertex.yz * scale)));
                        half3 yAxis = UnpackNormal(tex2D(texSampler, (vertex.xz * scale)));
                        half3 zAxis = UnpackNormal(tex2D(texSampler, (vertex.xy * scale)));

                        return xAxis * blending.x + yAxis * blending.y + zAxis * blending.z;
                }

                half3 GetTriplanar(sampler2D texSampler, half3 vertex, half3 blending, half scale)
                {
                        half3 xAxis = tex2D(texSampler, (vertex.yz * scale));
                        half3 yAxis = tex2D(texSampler, (vertex.xz * scale));
                        half3 zAxis = tex2D(texSampler, (vertex.xy * scale));

                        return xAxis * blending.x + yAxis * blending.y + zAxis * blending.z;
                }

                void surf (Input IN, inout SurfaceOutputStandard o) 
                {
                        o.Albedo = GetTriplanar(_MainTex, IN.vertex, IN.blending, 1) * _Color;
                        o.Metallic = _Metallic;
                        o.Normal = GetNormalMapTriplanar(_Bump, IN.vertex, IN.blending, 1.0);
                        o.Smoothness = _Glossiness;
                        o.Alpha = 1.0;
                }
                ENDCG
        }
        FallBack "Diffuse"
}
