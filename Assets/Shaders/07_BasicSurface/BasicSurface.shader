// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Cg Basic Surface" 
{
    Properties 
    {
    	
    	_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
    	_Emission("Emission", Color) = (0, 0, 0, 0)
        _MainTex("Main texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Shininess("Shininess", Range(1.0, 128)) = 10
    }
    
	SubShader 
    {
		Tags{ "RenderType" = "Opaque" }
        
			CGPROGRAM

            // Define what functions are used for the vertex shader and for the fragment shader
            #pragma surface surf CustomLighting fullforwardshadows
            #pragma vertex vert

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _NormalMap;

            fixed4 _Color;
            fixed4 _Emission;

    		half _Shininess;

    		struct Input 
    		{
    			float2 uv_MainTex;
    		};

    		struct CustomSurfaceOutput
    		{
    			// Standard surface shader fields
    			float3 Albedo;
    			float3 Normal;
    			float3 Emission;
    			float3 Alpha;
    		};

			void vert(inout appdata_full v, out Input output)
			{
				v.vertex.xyz += v.normal * sin(_Time.w + v.vertex.x * 20.0) * 0.05;

				// Insert in the input structure all correct values
				UNITY_INITIALIZE_OUTPUT(Input, output);

			}

			half4 LightingCustomLighting(CustomSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
			{
				// Get diffuse component
				half diffuseComponent = max(0, dot(s.Normal, lightDir));
				// Get reflected light direction
				half3 reflectedLightDir = normalize(reflect(-lightDir, s.Normal));
				// Compute specular component
				half specularComponent = max(0.0, dot(reflectedLightDir, viewDir));
				// Compute specular color
				half3 specularColor = _LightColor0.rgb * pow(specularComponent, _Shininess);
				// Compute light color with diffuse component
				fixed3 lightColor = _LightColor0.rgb * diffuseComponent;

				half4 color;
				color.rgb = (s.Albedo * lightColor + specularColor) * atten;
				color.rgb += s.Emission;

				color.a = s.Alpha;

				return color;
			}


			void surf(Input input, inout CustomSurfaceOutput output)
			{
				fixed4 mainColor = tex2D(_MainTex, input.uv_MainTex) * _Color;

				output.Albedo = mainColor.rgb;
				output.Emission = _Emission;

				output.Normal = UnpackNormal(tex2D(_NormalMap, input.uv_MainTex));

				output.Alpha = mainColor.a;

			} 

            ENDCG
        
    }

}
