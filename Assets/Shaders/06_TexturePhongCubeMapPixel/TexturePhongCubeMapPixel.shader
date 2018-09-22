// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Cg texture phong cubemap pixel" 
{
    Properties 
    {
        _MainTex("Main texture", 2D) = "White" {}
        _ReflectionMap("Reflection Map", Cube) = "White" {}
        _LightDir("Light direction", Vector) = (1.0, 0.0, 0.0, 0.0)
        _LightColor("Light color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Shininess("Shininess", Range(1.0, 128)) = 10
        _Reflectivity("Reflectivity", Range(0.0, 1.0)) = 0.1
    }
    
    SubShader 
    {
        Blend SrcAlpha OneMinusSrcAlpha
        Tags{ "Queue" = "Transparent" }
        
            Pass
            {
                CGPROGRAM

                // Define what functions are used for the vertex shader and for the fragment shader
                #pragma vertex vert
                #pragma fragment frag


                #include "UnityCG.cginc"

                sampler2D _MainTex;
                float4 _MainTex_ST; // Required to have unity fill the values from the sampler

                samplerCUBE _ReflectionMap;

                float3 _LightDir;
                float3 _LightColor;
                float _Shininess;
                float _Reflectivity;


                // Shader input definition
                struct AppData {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : NORMAL;
                };

                // Structure used for passing data from vertex to fragment shader
                struct VertexToFragment {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : TEXCOORD1;
                    float3 viewDir : TEXCOORD2;
                };

                // Vertex Shader
                VertexToFragment vert(AppData input) {
                    VertexToFragment output;

					// Compute transform vertex and uv
                    output.pos = UnityObjectToClipPos(input.vertex);
                    output.uv = TRANSFORM_TEX(input.uv, _MainTex);

					// Just pass normal and viewdir to fragment
                    output.normal = input.normal;
                    output.viewDir = normalize(ObjSpaceViewDir(input.vertex));

                    return output;
                }

                // Fragment Shader
                float4 frag(VertexToFragment input) : COLOR
                {
                    
					// Fragment require to renormalize vectors after per pixel projection
                    float3 normal = normalize(input.normal);
                    float3 viewDir = normalize(input.viewDir);
                    float3 lightDir = normalize(_LightDir);
                    float3 reflectedLightDir = normalize(reflect(-lightDir, normal));

					// Compute diffuse and specular components
                    float diffuseComponent = max(0.0, dot(lightDir, normal));
                    float specularComponent = max(0.0f, dot(reflectedLightDir, viewDir));

					// Compute diffuse and specular color
                    float3 lightColor = _LightColor * diffuseComponent;
                   	float3 specularColor = _LightColor * pow(specularComponent, _Shininess);

					// Get reflection color from cubemap sampler
                   	float3 reflectionVector = reflect(-viewDir, normal);
                	float3 reflectionColor = texCUBE(_ReflectionMap, reflectionVector) * _Reflectivity;

					// Get texture color
                	float4 textureColor = tex2D(_MainTex, input.uv);

					// Combine diffuse, specular, shiness and cubemap to texture color
                	textureColor.rgb *= lightColor;
                	textureColor.rgb += specularColor + reflectionColor;

                	return textureColor;
                }

                ENDCG
        }
        
    }

}
