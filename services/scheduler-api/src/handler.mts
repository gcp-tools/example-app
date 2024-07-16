import type { Request, Response } from '@google-cloud/functions-framework'
import * as functions from '@google-cloud/functions-framework'

functions.http('main', (_: Request, res: Response) => res.status(200).send('woohoo hoo hoo!'));
