﻿Shader "Custom/TextureCoordinates/Polkagris"
{
	Properties
	{
		_first_color ("First Color", Color)		= (1,0,0,1)
		_second_color ("Second Color", Color)	= (1,1,0,1)
		_speed ("Speed Of Polkagris", float)	= 1
		_num_lines ("Number Of Lines", int)		= 100
	}

	SubShader
	{
		Pass
		{
			Name "Colors"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			
			// Colors
			float4 	_first_color;
			float4 	_second_color;
			float	_speed;
			float	_num_lines;
			
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
				float	off_set = _Time * _speed;
				
				fragmentInput o;
				o.position = mul (UNITY_MATRIX_MVP, i.vertex);
				o.texcoord0 = i.texcoord0;
				o.texcoord0.y += off_set;
				o.texcoord0.x += (o.texcoord0.y);
				return o;
			}

			float4 frag(fragmentInput i) : COLOR
			{
				float4	color;
				//color = lerp(_first_color, _second_color,  smoothstep(-0.7, 0.7, sin(i.texcoord0.x*_num_lines)));
				color = lerp(_first_color, _second_color, (fmod(i.texcoord0.x *_num_lines,2.0) < 1.0));
				return color;
			}
			ENDCG
		}
	}
}