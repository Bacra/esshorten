# Copyright (C) 2014 Yusuke Suzuki <utatane.tea@gmail.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS'
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

'use strict'

esshorten = require '../'
expect = require('chai').expect

describe 'mangle', ->
    it 'base', ->
        program =
            "type": "Program",
            "body": [
                {
                    "type": "FunctionDeclaration",
                    "id": {
                        "type": "Identifier",
                        "name": "code"
                    },
                    "params": [
                        {
                            "type": "Identifier",
                            "name": "a1"
                        },
                        {
                            "type": "Identifier",
                            "name": "a2"
                        },
                        {
                            "type": "Identifier",
                            "name": "a3"
                        },
                        {
                            "type": "Identifier",
                            "name": "a4"
                        },
                        {
                            "type": "Identifier",
                            "name": "a5"
                        }
                    ],
                    "body": {
                        "type": "BlockStatement",
                        "body": [
                            {
                                "type": "VariableDeclaration",
                                "declarations": [
                                    {
                                        "type": "VariableDeclarator",
                                        "id": {
                                            "type": "Identifier",
                                            "name": "b1"
                                        },
                                        "init": null
                                    },
                                    {
                                        "type": "VariableDeclarator",
                                        "id": {
                                            "type": "Identifier",
                                            "name": "b2"
                                        },
                                        "init": null
                                    },
                                    {
                                        "type": "VariableDeclarator",
                                        "id": {
                                            "type": "Identifier",
                                            "name": "b3"
                                        },
                                        "init": null
                                    },
                                    {
                                        "type": "VariableDeclarator",
                                        "id": {
                                            "type": "Identifier",
                                            "name": "b4"
                                        },
                                        "init": null
                                    },
                                    {
                                        "type": "VariableDeclarator",
                                        "id": {
                                            "type": "Identifier",
                                            "name": "b5"
                                        },
                                        "init": null
                                    }
                                ],
                                "kind": "var"
                            }
                        ]
                    },
                    "generator": false,
                    "expression": false,
                    "async": false
                }
            ],
            "sourceType": "script"

        result1 = esshorten.mangle program,
            distinguishFunctionExpressionScope: no
        expect(result1.body[0].params[0].name).to.equal 'a'
        expect(result1.body[0].body.body[0].declarations[0].id.name).to.equal 'f'


        result2 = esshorten.mangle program,
            distinguishFunctionExpressionScope: yes
        expect(result2.body[0].params[0].name).to.equal 'a'
        expect(result2.body[0].body.body[0].declarations[0].id.name).to.equal 'f'

        result3 = esshorten.mangle program
        expect(result3.body[0].params[0].name).to.equal 'a'
        expect(result3.body[0].body.body[0].declarations[0].id.name).to.equal 'f'


    it 'function expression JSC bug', ->
        program =
            "type": "Program",
            "body": [
                {
                    "type": "ExpressionStatement",
                    "expression": {
                        "type": "FunctionExpression",
                        "id": {
                            "type": "Identifier",
                            "name": "name"
                        },
                        "params": [],
                        "defaults": [],
                        "body": {
                            "type": "BlockStatement",
                            "body": [
                                {
                                    "type": "VariableDeclaration",
                                    "declarations": [
                                        {
                                            "type": "VariableDeclarator",
                                            "id": {
                                                "type": "Identifier",
                                                "name": "i"
                                            },
                                            "init": {
                                                "type": "Literal",
                                                "value": 42,
                                                "raw": "42"
                                            }
                                        }
                                    ],
                                    "kind": "var"
                                }
                            ]
                        },
                        "rest": null,
                        "generator": false,
                        "expression": false
                    }
                }
            ]

        result1 = esshorten.mangle program,
            distinguishFunctionExpressionScope: no
        expect(result1.body[0].expression.id.name).to.equal 'a'
        expect(result1.body[0].expression.body.body[0].declarations[0].id.name).to.equal 'b'


        result2 = esshorten.mangle program,
            distinguishFunctionExpressionScope: yes
        expect(result2.body[0].expression.id.name).to.equal 'a'
        expect(result2.body[0].expression.body.body[0].declarations[0].id.name).to.equal 'a'

        result3 = esshorten.mangle program
        expect(result3.body[0].expression.id.name).to.equal 'a'
        expect(result3.body[0].expression.body.body[0].declarations[0].id.name).to.equal 'b'
