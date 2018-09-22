// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Cg Lava" 
{
    Properties 
    {
    	
    	_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
    	_Emission("Emission", Color) = (0, 0, 0, 0)
        _MainTex("Main texture", 2D) = "white" {}
        _LavaTex("Lava texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _OcclusionMap("Occlusion Map", 2D) = "bump" {}
        _Shininess("Shininess", Range(1.0, 256)) = 10
        _LavaAmount("Lava Amount", Range(0, 1)) = .2
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
            sampler2D _LavaTex;
            sampler2D _NormalMap;
			sampler2D _OcclusionMap;

            fixed4 _Color;
            fixed4 _Emission;

    		half _Shininess;
			half _LavaAmount;

    		struct Input 
    		{
    			float2 uv_MainTex;
    			float2 uv_LavaTex;
    			float2 uv_OcclusionMap;
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
				fixed4 LavaColor = tex2D(_LavaTex, input.uv_LavaTex+ _Time/100.) * _Color;
				fixed4 Occlusion = tex2D(_OcclusionMap, input.uv_OcclusionMap);

				float lerpValue = pow(Occlusion.r, _LavaAmount * 15);

				float randomwave = abs(sin(input.uv_MainTex.x * cos(-input.uv_MainTex.y * 50) * _LavaAmount + _LavaAmount ));

				lerpValue = lerp(1, lerpValue, _LavaAmount + randomwave);


				output.Albedo = lerp(LavaColor, mainColor, lerpValue);

				output.Emission = _Emission;

				output.Normal = UnpackNormal(tex2D(_NormalMap, input.uv_MainTex));

			} 

            ENDCG
        
    }

}
