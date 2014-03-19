Shader "Custom/TextureCoordinates/FourColors"
{
	Properties
	{
		_first_color ("First Color", Color)		= (1,0,0,1)
		_second_color ("Second Color", Color)	= (0,1,0,1)
		_third_color ("Third Color", Color)		= (0,0,1,1)
		_fourth_color ("Fourth Color", Color)	= (1,1,0,1)
		_num_squares ("Number Of Squares", int)	= 4
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			
			// Colors
			float4 	_first_color;
			float4 	_second_color;
			float4	_third_color;
			float4	_fourth_color;
			float	_num_squares;
			
			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 texcoord0 : TEXCOORD0;
			};

			struct fragmentInput
			{
				float4 position : SV_POSITION;
				float4 texcoord0 : TEXCOORD0;
			};

			fragmentInput vert(vertexInput i)
			{				
				fragmentInput o;
				o.position = mul (UNITY_MATRIX_MVP, i.vertex);
				o.texcoord0 = i.texcoord0;
				
				return o;
			}

			float4 frag(fragmentInput i) : COLOR
			{
				
				float4	color = (0,0,0,1);
				
				if ( fmod(i.texcoord0.x*_num_squares,2.0) < 1.0  )
				{
					if ( fmod(i.texcoord0.y*_num_squares,2.0) < 1.0 )
					{
						color = _first_color;
					}
					else
					{
						color = _second_color;
					}
				}
				else 
				{
					if ( fmod(i.texcoord0.y*_num_squares,2.0) > 1.0 )
					{
						color = _third_color;
					}
					else
					{
						color = _fourth_color;
					}
				}
				
				return color;
			}
			ENDCG
		}
	}
}