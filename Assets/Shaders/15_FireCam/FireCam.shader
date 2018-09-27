Shader "Hidden/FireCam"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_FireTex("Fire Texture", 2D) = "white" {}
		_FireAmount("Fire Amount", Range(0,1)) = 0.4
	}
	SubShader
	{
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			sampler2D _MainTex;
			sampler2D _FireTex;
			half _FireAmount;
			
			
			fixed4 frag (v2f_img i) : SV_Target
			{
				// sample the texture
				fixed4 fireCol = tex2D(_FireTex, i.uv);


				fixed2 uvValue = i.uv + (fireCol.rg) * _FireAmount;
				fixed4 col = tex2D(_MainTex, uvValue);

				/*
				half lerpValue = floor(fireCol.r + .5) * .5;
				float offset = .005;
				
				col = lerp(col, tex2D(_MainTex, uvValue + fixed2(0, offset)), lerpValue);
				col = lerp(col, tex2D(_MainTex, uvValue + fixed2(0, -offset)), lerpValue);
				col = lerp(col, tex2D(_MainTex, uvValue + fixed2(offset, 0)), lerpValue);
				col = lerp(col, tex2D(_MainTex, uvValue + fixed2(-offset, 0)), lerpValue);
				*/

				return col;
			}
			ENDCG
		}
	}
}
