Shader "Custom/Cg unlit color"
{
	Properties
	{
		_MainColor("Main color", Color) = (1.0, 1.0, 1.0, 1.0)

	}

		SubShader
	{
		Pass
	{
		CGPROGRAM

		// Define what functions are used for the vertex shader and for the fragment shader
#pragma vertex vert
#pragma fragment frag

		float4 _MainColor;

	// Shader input definition
	struct AppData
	{
		float4 vertex : POSITION;
	};

	// Structure used for passing data from vertex to fragment shader
	struct VertexToFragment
	{
		float4 pos : SV_POSITION;
	};

	// Vertex Shader
	VertexToFragment vert(AppData input)
	{
		VertexToFragment output;

		// Example 1:
		//output.pos = mul(UNITY_MATRIX_MV, input.vertex);
		//output.pos = mul(UNITY_MATRIX_P, output.pos);

		// Example 2:
		//output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

		// Optimized function by Unity3D
		output.pos = UnityObjectToClipPos(input.vertex);

		return output;
	}

	// Fragment Shader
	float4 frag(VertexToFragment input) : COLOR
	{
		return _MainColor;
	}
		ENDCG
	}
	}
}